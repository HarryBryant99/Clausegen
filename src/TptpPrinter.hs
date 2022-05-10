module TptpPrinter (
     putFormulaListPara,
     putFormulaListParaConj,
     putFormulaListParaConject,
     putFormulaListParaConjectEnd,
     putFormulaListFleetConject,
     putFormulaListFleetConjectEnd,
     getVars,
     getVarsPara,
    ) 
    where

-------------------------------------------------------------

import qualified Data.Set as Set
import Data.List
import Data.Char
import Formula

paradox :: Int -> Formula -> String
paradox n (And a b) = '(' : (paradox n a) ++ " & " ++ (paradox n b) ++ ")"
paradox n (Or a b) =  '(' : (paradox n a) ++ " |  " ++ (paradox n b) ++ ")"
paradox n (Not a) = "~ " ++ (paradox n a)
paradox n (Iff a b) =  (paradox n a) ++ " <=> " ++ (paradox n b) 
paradox n (Var s v) = giveVarPara3 n (Var s v) -- CHANGED 2 -> 3
paradox n Top = "true"

putFormulaListPara :: Int -> [Formula] -> String
putFormulaListPara n fs = 
  concat $ map (\f -> ("fof(ax,axiom, " ++ (paradox n f)) ++ ").\n") fs

putFormulaListParaConj :: Int -> [Formula] -> String
putFormulaListParaConj n fs = 
  "fof(ax,conjecture, " ++ 
  (concat $ map (\f -> (paradox n f) ++ " & \n") fs) 
  ++ "$true) ."



putFormulaListParaConject :: Int -> [Formula] -> String
putFormulaListParaConject n fs = 
  (concat $ map (\f -> (paradox n f) ++ " & \n") fs)

putFormulaListParaConjectEnd :: Int -> [Formula] -> String
putFormulaListParaConjectEnd n fs = 
  (concat $ map (\f -> (paradox n f) ++ ") .") fs)



----------------------------------------------

putFormulaListFleetConject :: Int -> [Formula] -> Formula -> String
putFormulaListFleetConject n fs fleet = 
  paradox (n+1) fleet ++ (concat $ map (\f -> (paradox n f) ++ " & \n") fs) 

putFormulaListFleetConjectEnd :: Int -> [Formula] -> Formula -> String
putFormulaListFleetConjectEnd n fs fleet = 
  paradox (n+1) fleet ++ (concat $ map (\f -> (paradox n f) ++ ") .") fs)

-----------------------------------------------



getVars :: Int -> [Formula] -> [String]
getVars n fs =  Set.elems (Set.unions $ map (getVarsAux n) fs)

getVarsAux :: Int -> Formula -> Set.Set String
getVarsAux n (And a b) = Set.union (getVarsAux n a) (getVarsAux n b)  
getVarsAux n (Or a b)  = Set.union (getVarsAux n a) (getVarsAux n b)
getVarsAux n (Not a)   = (getVarsAux n a)
getVarsAux n (Iff a b) = Set.union (getVarsAux n a) (getVarsAux n b)
getVarsAux n (Var s v) = checkVar  (giveVar n (Var s v))
getVarsAux n Top = Set.empty



getVarsPara :: Int -> [Formula] -> [String]
getVarsPara n fs =  Set.elems (Set.unions $ map (getVarsAuxPara n) fs)


getVarsAuxPara :: Int -> Formula -> Set.Set String
getVarsAuxPara n (And a b) = Set.union (getVarsAuxPara n a) (getVarsAuxPara n b)  
getVarsAuxPara n (Or a b)  = Set.union (getVarsAuxPara n a) (getVarsAuxPara n b)
getVarsAuxPara n (Not a)   = (getVarsAuxPara n a)
getVarsAuxPara n (Iff a b) = Set.union (getVarsAuxPara n a) (getVarsAuxPara n b)
getVarsAuxPara n (Var s v) = giveVarPara n (Var s v)
getVarsAuxPara n Top = Set.empty


checkVar :: String -> Set.Set String
checkVar n = if (isInfixOf "__" n) 
             then Set.singleton $ (replace "__" "_'_" n)
             else if (isInfixOf "-" n)
                  then Set.singleton $ (replace "-" "'" n)
                   else Set.singleton $ n

checkVar2 :: String -> String
checkVar2 n = if (isInfixOf "__" n) 
             then (replace "__" "_'_" n)
             else if (isInfixOf "-" n)
                  then (replace "-" "'" n)
                   else n

giveVar :: Int -> Formula -> String
giveVar n (Var s v) =  ('V':(map (\x->if (x=='(' ||  x=='-' || x==')' || x=='.' || x=='/') then '_' else x) s)) ++ "'" ++ (show n)


giveVar2 :: Int -> Formula -> String
giveVar2 n (Var s v) = show s

giveVarPara :: Int -> Formula -> Set.Set String
giveVarPara n (Var s v) = case n of
                  (-1) ->  Set.singleton (('v':(map (\x->if (x=='(' ||  x=='-' || x==')' || x=='.' || x=='/' || x==' ') then '_' else x) s)) ++ "_")
                  _    ->  Set.singleton (('v':(map (\x->if (x=='(' ||  x=='-' || x==')' || x=='.' || x=='/' || x==' ') then '_' else x) s)) ++ "_" ++ show n)


giveVarPara2 :: Int -> Formula -> String
giveVarPara2 n (Var s v) = ('v':(map (\x->if (x=='(' || x=='-' || x==')' || x=='.' || x=='/' || x==' ') then '_' else x) s)) ++ "_" ++ (show (v+n))


giveVarPara3 :: Int -> Formula -> String
giveVarPara3 n (Var s v) = if (last(init s) =='_')
                           then giveVarPara2 n (Var (init(init s)) ((digitToInt(last s)) + v))
                           else giveVarPara2 n (Var s v)

                        
replace :: (Eq a) => [a] -> [a] -> [a] -> [a]
replace _ _ [] = []
replace old new xs@(y:ys) =
  case stripPrefix old xs of
    Nothing -> y : replace old new ys
    Just ys' -> new ++ replace old new ys' 