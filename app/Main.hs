{-# LANGUAGE DeriveDataTypeable #-}

module Main where

import Control.Concurrent
import Control.Concurrent.MVar
import Control.Exception.Base
import System.IO.Unsafe
import System.IO
import System.Process
import System.Environment
import System.Console.CmdArgs

import GcssParser.GcssParserTokeniser hiding (Tokens(..))
import GcssParser.GcssParser
import Data.List
import Formula
import Ladder
import Compiler
import FormulaTree hiding (children)
import ClauseSet
import CNF
import Safety
import Slicer
import TptpPrinter

printTp :: String -> [Formula] -> [Int] -> IO()
printTp filename ladder n = do
  h <- getAndOpenFile filename WriteMode
  sequence_ (map (\x -> hPutStrLn h (putFormulaListPara x ladder) ) n)                                       
  hClose h
  return()

printInitialTp :: [Formula] -> IO()
printInitialTp ladder = do
  h <- getAndOpenFile "Initial.tptp" WriteMode
  let putVar v = do
        hPutStrLn h ("fof(ax,axiom,  ~" ++ v ++ ") .\n")
        return()
  sequence_ $ map putVar (getVarsPara 0 ladder)
  hClose h
  return()

-- CHANGED: added checkNewFormat and then, else
printSafetyBase ::[Formula] -> IO()
printSafetyBase sc = do
  h <- getAndOpenFile "SafetyBase.tptp" WriteMode
  if checkNewFormat (extractVars2 (sc !! 0) )
    then do 
       hPutStrLn h (putFormulaListParaConj 1 sc)
    else do
       hPutStrLn h (putFormulaListParaConj 0 sc)
  hClose h 

  return() 

-- CHANGED: added checkNewFormat and then, else
printSafetyStep :: [Formula] -> IO()
printSafetyStep sc = do
  h <- getAndOpenFile "SafetyStep.tptp" WriteMode
  if checkNewFormat (extractVars2 (sc !! 0) )
     then do
        hPutStrLn h (putFormulaListPara (0) sc)
        hPutStrLn h (putFormulaListParaConj 1 sc)
     else do
        hPutStrLn h (putFormulaListPara (-1) sc)
        hPutStrLn h (putFormulaListParaConj 0 sc)

  hClose h
  return() 

-- CHANGED: added checkNewFormat and then, else
printSafety :: Int -> [Formula] -> IO()
printSafety n sc = do
  h <- getAndOpenFile "Safety.tptp" WriteMode
  hPutStrLn h ("fof(ax,conjecture,") 
  if checkNewFormat (extractVars2 (sc !! 0) )
    then do 
       (sequence_ (map (\x -> hPutStrLn h (putFormulaListParaConject x sc)) [0..(n-1)]))
       hPutStrLn  h (putFormulaListParaConjectEnd (n) sc) 
    else do 
       (sequence_ (map (\x -> hPutStrLn h (putFormulaListParaConject x sc)) [-1..(n-2)]))
       hPutStrLn  h (putFormulaListParaConjectEnd (n-1) sc) 
  hClose h
  return()

-----------------------------------------------------

printFleeting :: Int -> [Formula] -> Formula -> IO()
printFleeting n sc fleet = do
  h <- getAndOpenFile "Fleeting.tptp" WriteMode
  hPutStrLn h ("fof(ax,conjecture,") 
  if checkNewFormat (extractVars2 (sc !! 0) )
    then do 
       (sequence_ (map (\x -> hPutStrLn h (putFormulaListFleetConject x sc fleet)) [0..(n-1)]))
       hPutStrLn  h (putFormulaListParaConjectEnd (n) sc) 
    else do 
       (sequence_ (map (\x -> hPutStrLn h (putFormulaListFleetConject x sc fleet)) [-1..(n-2)]))
       hPutStrLn  h (putFormulaListParaConjectEnd (n-1) sc) 
  hClose h
  return()


createSRLatchFormula :: [(String, String, String)] -> [Formula]
createSRLatchFormula ([]) = [] 
createSRLatchFormula ((s1,s2,s3) : srs) = [(Not (And (Var s2 0) (Var s3 0)))] ++ (createSRLatchFormula srs)


-----------------------------------------------------

printLadder :: Handle -> Int -> IO()
printLadder h n = do
  hPutStrLn h ("Ladder" ++ (show n) ++ "\nthen" )
  return()

getAndOpenFile :: String -> IOMode -> IO Handle
getAndOpenFile name mode = do
      openFile name mode
        
printBaseVerification :: IO()
printBaseVerification = do 
  h <- getAndOpenFile "BaseCase.tptp" WriteMode
  hPutStrLn h "include('Initial.tptp') ."
  hPutStrLn h "include('Ladder.tptp') ."
  hPutStrLn h "include('SafetyBase.tptp') ."
  hClose h
  return()

printStepVerification :: IO()
printStepVerification = do 
  h <- getAndOpenFile "StepCase.tptp" WriteMode
  hPutStrLn h "include('Ladder.tptp') ."
  hPutStrLn h "include('SafetyStep.tptp') ."
  hClose h
  return()

printBMC :: IO()
printBMC = do 
  h <- getAndOpenFile "BMC.tptp" WriteMode
  hPutStrLn h "include('Initial.tptp') ."
  hPutStrLn h "include('Ladder.tptp') ."
  hPutStrLn h "include('Safety.tptp') ."
  hClose h
  return()


printSafetyNew :: Int -> [Formula] -> IO()
printSafetyNew n sc = do
  h <- getAndOpenFile "Safety.tptp" WriteMode
  hPutStrLn h ("fof(ax,axiom,") 
  sequence_ (map (\x -> hPutStrLn h (putFormulaListParaConject x sc)) [-1..(n-1)])
  hPutStrLn  h (putFormulaListParaConjectEnd (n) sc)
  hClose h
  return()

data Clausgen = Clausgen {ladderFile :: String, safetyFile :: String, proofStrategy :: String, bound :: String, generateLadder :: String, performSlicing :: String}
              deriving (Show, Data, Typeable)

defaultOptions = Clausgen{ladderFile = "ladder.wt2" &= help "(optional) The path to the ladder logic file. Default: ladder.wt2"
  , safetyFile = "safety.cond" &= help "(optional) The path to the safety condition file. Default: safety.cond"
  , proofStrategy="inductive" &= help "(optional) The proof strategy to use. Supported options: inductive, bmc. Default: inductive"
  , bound="0" &= help "(optional) The bound to use when using the bmc proof strategy. Default: 0"
  , generateLadder="no" &=help "(optional) Specify whether or not to regenerate ladder.tptp file. Supported options: yes, no. Default: no"
  , performSlicing = "no" &=help "(optional) Indicates whether to perform slicing on the ladder logic or not. Default: no"
}

--entry point
main :: IO ()
main =  do 
  args <- cmdArgs defaultOptions
  let ladderArg = ladderFile args
  let safetyArg = safetyFile args
  let verifArg =  proofStrategy args
  let stepsArg = bound args
  let genArg = generateLadder args
  let sliceArg = performSlicing args
  
  source <- readFile ladderArg
  let num = read stepsArg::Int                               
  let (ladder, srlatches) = (gcss.alexScanTokens) source
--  let ladder = fst((gcss.alexScanTokens) source)
  let compiled = (compile 1 ladder)
  let srformula = createSRLatchFormula srlatches
  rawscript <- readFile safetyArg
  let script = readSafetyConditions (fst ladder) rawscript
  let sc = [((script !! 0) 0)]
  case verifArg of
    "inductive" ->   do

      printInitialTp compiled --Slice?
      case genArg of
        "yes" -> do
            case sliceArg of
              "yes" -> do 
                let slicedladder = slice compiled (extractVars2 (sc !! 0))
                printTp "Ladder.tptp" slicedladder [0..1] 
              "no" -> do 
                printTp "Ladder.tptp" compiled [0..1] 
        "no" -> return();

--      printTp "SRLatches.tptp" srlarches [0..1]
      printSafetyBase sc
      printSafetyStep sc
      printBaseVerification
      printStepVerification
      system "z3_tptp.exe BaseCase.tptp"
      system "z3_tptp.exe StepCase.tptp"                            
      return()
    "bmc" -> do
      printInitialTp compiled --Slice?
      case genArg of
        "yes" -> do
            case sliceArg of
              "yes" -> do 
                let slicedladder = slice compiled (extractVars2 (sc !! 0))
                printTp "Ladder.tptp" slicedladder [0..num]
              "no" -> do 
                printTp "Ladder.tptp" compiled [0..num] 
        "no" -> return();
--    printTp "SRLatches.tptp" srlarches [0..num]
      printSafety num sc
      printBMC
      system "z3_tptp.exe -m BMC.tptp"                                
      return()          
      
