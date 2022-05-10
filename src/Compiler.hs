---------------------------------------------------------------
--  
-- |
-- Module:       Compiler
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- This module is a compiler from ladder logic to propositional logic,
-- this is done in three steps, first the propositional logic is 
-- produced for each rung then veriables are renamed to allow for the 
-- sequential nature of the execution cycle. finally the formulas are 
-- combined into a single large formula for the ladder.
-- 
---------------------------------------------------------------

module Compiler(
    compilecells,
    compilerung,
    compilerungs,
    
    compile,
    rename
    ) 
    where

import Data.List
import Formula
import Ladder
import GcssParser.GcssParser
import Safety

-- | Top level function to compile a ladder to propositional logic.
-- Given an integer and a ladder with variable maps, returns a 
-- propositional formula representing an execution of the ladder 
-- after n steps. Along with a substitution used to rename variables.
-- compile :: Int -> (Ladder,VarMaps) -> [Formula]--(Maybe Formula, Substitution)
-- compile n ((Root rs),vms) = let f a b = And a b
--                                 g (s,b,_) = if (b) then (Var s 0) else (Not (Var s 0))
--                                 initialvars = map g (vms ++ reservedlatches)
--                                 crungs = ((compilerungs n vms). extractrungs) (Root rs)
--                                 crungs = ((compilerungs.extractrungs) (Root rs), idsubst)
--                                 --ladder = foldr f (head (fst crungs)) (tail (fst crungs))
--                                 --initial = (foldr f (head initialvars) (tail initialvars))
--                             in fst crungs --(Just (And ladder initial), (snd crungs))
-- compile _ _ = (Nothing, idsubst)


compile :: Int -> (Ladder,VarMaps) -> [Formula]
compile n ((Root rs),vms) = let f a b = And a b
                                g (s,b,_) = if (b) then (Var s 0) else (Not (Var s 0))
                                initialvars = map g (vms ++ reservedlatches)
                                crungs = ((compilerungs n vms). extractrungs) (Root rs)
                            in fst crungs 
--compile _ _ = (Nothing, idsubst)


-- | Translates each rung into a propositional formula using the variable
-- mappings. Then returns a list of formula's representing the translation
-- of each rung, along with the substitution that has been used to rename
-- variables.
compilerungs :: Int -> VarMaps -> [Ladder] -> ([Formula],Substitution)
compilerungs n v rungs  = createIterations n (map compilerung rungs) v idsubst


--compilerungs2 :: (Ladder,VarMaps) -> [Formula]
--compilerungs2 (Root rs, vms) = let rungs = extractrungs (Root rs)
                               -- in map compilerung rungs  

--compilerungs :: [Ladder] -> [Formula]
--compilerungs rungs = map compilerung rungs

{-
# Phase 1 #
-}

-- | Data type  used to determine
-- if the cell is to have its code
-- processed or just visited
data Visitable a =  Visiting a                             
                  | Processing a
                    deriving Show

-- |result of function computenextcords, the first two integers represent coordanates
-- x and y. The celllinks is the direction of the link from the current cell in question.
-- Finaly the boolean determins if the cell should have any code generated or just
-- visited.
type CellCords = (Int,Int,CellLinks,Bool)

-- | Simple constructor for the Visitable data type
visitable :: Ladder -> Bool -> Visitable Ladder
visitable l True = Visiting l
visitable l False = Processing l

-- | removes the given celllink from the cell if
-- possible, otherwise it does nothing.
removecelllink :: CellLinks -> Ladder -> Ladder
removecelllink LinkTop (Cell a b c d lnks) = (Cell a b c d (delete LinkBottom lnks))
removecelllink LinkBottom (Cell a b c d lnks) = (Cell a b c d (delete LinkTop lnks))
removecelllink _ (Cell a b c d lnks) = (Cell a b c d lnks)
removecelllink _ NoLadder = NoLadder

-- | Translates the given rung into a 
-- propositional formula, by performing various
-- operations on the cells that make up the 
-- rung.
compilerung :: Ladder -> Formula
compilerung (Rung n cs) = compilecells (Processing (extractcell (testcellbytype CellTypeCoil) cs)) cs
                                        
-- | Given the current cords (y,x) in the given rung, with the
-- possible links compute the next cells to visit.
-- In the return record the boolean represents if the cell should 
-- have code produced for it or just to be visited as a stepping
-- stone to the next cell in the formula.
computenextcords :: Int -> Int -> [Ladder] -> [CellLinks] -> [CellCords]
computenextcords 1 x cs (LinkTop:cls) = computenextcords 1 x cs cls
computenextcords y 1 cs (LinkTop:cls) = computenextcords y 1 cs cls
computenextcords y x cs (LinkTop:cls) = let c = extractcell (testcellbyposn (y-1) x) cs
                                            ct = celltype c
                                            earthed = cellearthed (removecelllink LinkTop c) cs
                                        in
                                          if earthed then
                                          ((if (ct /= CellTypeNormally_Open) && (ct /= CellTypeNormally_Closed) 
                                          then (y-1,x,LinkTop,False)
                                          else (y-1,x,LinkTop,True)) : (computenextcords y x cs cls))
                                          else computenextcords y x cs cls
computenextcords y x cs [] = []
computenextcords y 1 cs (LinkBottom:cls) = computenextcords y 1 cs cls
computenextcords y x cs (LinkBottom:cls) = let c = extractcell (testcellbyposn (y+1) x) cs
                                               (Cell y' x' ct n lnks) = c
                                               earthed = cellearthed (removecelllink LinkBottom c) cs
                                           in
                                             if earthed then
                                             ((if (ct /= CellTypeNormally_Open) && (ct /= CellTypeNormally_Closed)
                                              then (y+1,x,LinkBottom,False)
                                              else (y+1,x,LinkBottom,True)):(computenextcords y x cs cls))
                                              else computenextcords y x cs cls
computenextcords y 1 cs (LinkLeft:cls) = computenextcords y 1 cs cls
computenextcords y x cs (LinkLeft:cls) = (y,max 1 (x-1),LinkLeft,False):(computenextcords y x cs cls)
computenextcords y x cs (LinkNone:cls) = computenextcords y x cs cls

-- | Checks if the given cell is directly linked to the power source
cellearthed :: Ladder -> [Ladder] -> Bool
cellearthed (Cell _ 1 _ _ _) _ = True
cellearthed (Cell y x _ _ lnks) cs = let cords = computenextcords y x cs lnks
                                         conv1 (a,b,c,_) = removecelllink c (extractcell (testcellbyposn a b) cs)
                                         conv2 x = cellearthed x cs 
                                     in
                                       or (map conv2 (map conv1 cords))

-- converts a cell into a formula by following its links back to the
-- source. Performs the main work of compiling a rung into a formula
-- when a coil is passed in.
--
-- the cell is visitable to stop cases of revisiting cells and
-- looping un-nessaceraly.
--
-- next a list of cells is passed that represents the whole rung,
-- as the formula of a given cell generally is dependant on other
-- cells.
compilecells :: Visitable Ladder -> [Ladder] -> Formula
-- if we are processing a coil
compilecells (Processing (Cell y x CellTypeCoil n lnks)) cs = 
  let -- list of connected cells to be explored as CellCords list
      cords = computenextcords y x cs lnks
      -- takes a CellCords record and produce a modified destination cell that
      -- does not have a back link so that when it is explored we do not return
      -- to the current cell
      conv1 (a,b,c,d) = visitable (removecelllink c (extractcell (testcellbyposn a b) cs)) d
      -- given a visitable cell compiles it into a formula
      conv2 x = compilecells x cs
      -- counts the number of cells that are directly linked to this cell which are to
      -- be explored.
      len = length cords
      -- compiles all linked cells into formulas
      forms = map conv2 (map conv1 cords)
  in
    case len of 
      0 -> Var n 0
      1 -> Iff (Var n 0) (head forms)
      2 -> Iff (Var n 0) (Or (head forms) (head (reverse forms)))
      3 -> Iff (Var n 0) (Or (head forms) (Or ((head . tail) forms) ((head . reverse) forms)))
-- if we are processing a normal variable
compilecells (Processing (Cell y x CellTypeNormally_Open n lnks)) cs = 
  let cords = computenextcords y x cs lnks
      conv1 (a,b,c,d) = visitable (removecelllink c (extractcell (testcellbyposn a b) cs)) d
      conv2 x = compilecells x cs
      len = length cords
      forms = map conv2 (map conv1 cords)
  in
    case len of 
      0 -> Var n 0
      1 -> And (Var n 0) (head forms)
      2 -> And (Var n 0) (Or (head forms) (head (reverse forms)))
      3 -> And (Var n 0) (Or (head forms) (Or ((head . tail) forms) (head (reverse forms))))
-- if we are processing a negated variable
compilecells (Processing (Cell y x CellTypeNormally_Closed n lnks)) cs = 
  let cords = computenextcords y x cs lnks
      conv1 (a,b,c,d) = visitable (removecelllink c (extractcell (testcellbyposn a b) cs)) d
      conv2 x = compilecells x cs
      len = length cords
      forms = map conv2 (map conv1 cords)
  in
    case len of 
      0 -> Not (Var n 0)
      1 -> And (Not (Var n 0)) (head forms)
      2 -> And (Not (Var n 0)) (Or (head forms) (head (reverse forms)))
      3 -> And (Not (Var n 0)) (Or (head forms) (Or ((head . tail) forms) (head (reverse forms))))
-- if we are processing a link
compilecells (Processing (Cell y x _ n lnks)) cs = 
  let cords = computenextcords y x cs lnks
      conv1 (a,b,c,d) = visitable (removecelllink c (extractcell (testcellbyposn a b) cs)) d
      conv2 x = compilecells x cs
      len = length cords
      forms = map conv2 (map conv1 cords)
  in
    case len of 
      0 -> Top
      1 -> head forms
      2 -> Or (head forms) (head (reverse forms))
      3 -> Or (head forms) (Or ((head . tail) forms) (head (reverse forms))) 
-- if we are only visiting a cell
compilecells (Visiting (Cell y x t n lnks)) cs = 
  let cords = computenextcords y x cs lnks
      conv1 (a,b,c,d) = visitable (removecelllink c (extractcell (testcellbyposn a b) cs)) d
      conv2 x = compilecells x cs
      len = length cords
      forms = map conv2 (map conv1 cords)
  in
    case len of 
      0 -> Not Top
      1 -> head forms
      2 -> Or (head forms) (head (reverse forms))
      3 -> Or (head forms) (Or ((head . tail) forms) (head (reverse forms)))
      

{-
############## Phase 2 ################
-}

-- used as a return type of renameformula, the first parameter is
-- a renamed formula and the final two parameters define the variable
-- name and the version it was raised to.
type RenameFormula = (Formula,Substitution)

-- an substitution, obviously they can be concatenated to
-- produce a complicated assignment that is built up over time.
type Substitution = Formula -> Formula

-- helper functions

-- the simple identity substitution
idsubst :: Substitution
idsubst f = f

-- substitutes a given varable version for another greater
-- version in the given formula
newsubst :: String -> Int -> Substitution
newsubst n v (Var n' v') = if (n == n') && (v > v')
                           then (Var n' v)
                           else (Var n' v')
newsubst n v (And f1 f2) = And (newsubst n v f1) (newsubst n v f2)
newsubst n v (Or f1 f2) = Or (newsubst n v f1) (newsubst n v f2)
newsubst n v (Not f) = Not (newsubst n v f)
newsubst n v (Iff f1 f2) = Iff (newsubst n v f1) (newsubst n v f2)
newsubst _ _ Top = Top

-- main renamming starts here


createIterations :: Int -> [Formula] -> VarMaps -> Substitution ->([Formula],Substitution)
createIterations 1 forms vars sub = rename forms sub
createIterations n forms vars sub = let (newform, newsub) = rename forms sub
                                        newnewsub = incrementVars newsub vars
                                   -- in (\(a,b)->(a,b)) (createIterations (n-1) newform vars newnewsub)--newnewsub
                                    in (\(a,b)->(a++newform,b)) (createIterations (n-1) newform vars newsub)--newnewsub        


-- | Given a substitution and a variable mapping, produces a new substitution with
-- various variable counters increased. ??? Should it include reserved latches.
incrementVars :: Substitution -> VarMaps -> Substitution
incrementVars phi [] = phi
incrementVars phi ((s,_,InputV) : t) = let f = phi (Var s 0)
                                       in
                                       case f of
                                         (Var st v) -> incrementVars(phi . (newsubst s (v+1))) t                
                                         _ -> incrementVars phi t
incrementVars phi (x : t) = incrementVars phi t

-- top level rename function
rename :: [Formula] -> Substitution -> ([Formula],Substitution)
--- instead of idsubt pass in old phi.
--- return phi to in tuple append to list of phis,
rename forms sub = rename2 sub forms

-- rename helper, steps through the list of formulas and
-- renames each one as appropriate, keeps track of the substitutions
-- as they are produced.
rename2 :: Substitution -> [Formula] -> ([Formula], Substitution)
--b is thrown  subst but need to pass in for next iteration
rename2 phi (form:[]) = (\(a,nKeep)->(a:[],nKeep)) (renameformula form phi)
rename2 phi (form:forms) = let (f,psi) = renameformula form phi
                           in  ((f:((\(a,_)->(a))(rename2 psi forms))),psi)

-- dependant upon the structure produced by compilecells
-- finds the left argument of the iff and incements its name
renameformula :: Formula -> Substitution -> RenameFormula
renameformula (Iff (Var n v) f) phi = let phi_new = phi . (newsubst n (v+1))
                                      in ((Iff (phi_new (Var n v)) (phi f)),phi_new) --- Apply phi at every rung...
renameformula f phi = (phi f,phi)
{-
for each time a coil (left side of iff) is found, increment the version of it
and in all subsequent formulas
-}


