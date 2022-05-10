
module Slicer (
     slice,
     extractVars,
     
     getDepVars,
     addVars,
     --sliceCriterion,
     removeRungs,
     removeExt,
    -- sc,
     getAllDepVars,
     
    ) 
    where

-------------------------------------------------------------

import Formula
import Data.Char
import Data.List

---------------------------------------
---Slicing 
---------------------------------------

slice :: [Formula] -> [Formula] -> [Formula]
slice ladder safety = removeRungs ladder (getAllDepVars ladder (removeExt safety) [])

removeExt :: [Formula] -> [Formula]
removeExt ls = map removeIndExt ls

removeIndExt :: Formula -> Formula
removeIndExt (And a b) = And (removeIndExt a) (removeIndExt b)
removeIndExt (Or a b) = Or (removeIndExt a) (removeIndExt b)
removeIndExt (Not a) = Not (removeIndExt a)
removeIndExt (Iff a b) = Iff (removeIndExt a) (removeIndExt b)
removeIndExt (Var s v) = if (last(init s) =='_')
                         then (Var (init(init s)) ((digitToInt(last s)) + v))
                         else (Var s v)
removeIndExt Top = Top

removeRungs :: [Formula] -> [Formula] -> [Formula]
removeRungs [] _ = []
removeRungs ((Iff a b) : xs) sc = if (elem a sc) then (Iff a b) : (removeRungs xs sc) else removeRungs xs sc 

-- check is nub needed?







getAllDepVars ::[Formula] -> [Formula] -> [Formula] -> [Formula]
getAllDepVars ladder [] used = used 
getAllDepVars ladder (sc:xs) used = nub (getAllDepVars ladder (addVars xs (getDepVars ladder sc) (sc : used)) (sc : used))


addVars :: [Formula] -> [Formula] -> [Formula] -> [Formula]
addVars f [] old = f
addVars f (x:xs) old = if (elem x old) then addVars f xs old else addVars (x:f) xs old 

--addVar :: [Formula] -> Formula -> [Formula]
--addVar f x = if (elem x f) then f else (x:f)


getDepVars :: [Formula] -> Formula -> [Formula]
getDepVars [] _ = []
getDepVars ((Iff (Var v 1) b) : xs) (Var v1 s) = if (((v == v1) ) ) then ((extractVars b) ++ (getDepVars xs (Var v1 s))) else getDepVars xs (Var v1 s)
getDepVars (_:xs) v = getDepVars xs v  


extractVars :: Formula -> [Formula]
extractVars (And a b) = (extractVars a) ++ (extractVars b)
extractVars (Or a b) = (extractVars a) ++ (extractVars b)
extractVars (Not a) = extractVars a
extractVars (Iff a b) = (extractVars a) ++ (extractVars b)
extractVars (Var s 1) = [(Var s 1)]  --- N here???
extractVars (Var s 0) = [(Var s 1)]
extractVars top = []



------
-- Ladder SC
-- make all vars in SC 1's.
-- look through ladder and check if any elems of SC = coil. If so:
-- 1. add elem to used list and remove from SC.
-- 2. add vars of rung to new list [] as long as not seen.
-- 3. remove rung form ladder (optional speed up).
-- Recursively do this with new list as long as it is non empty, if empty, done.

-- 
-- Complexity!!!!

recurse :: [Formula] -> [Formula] -> [Formula] -> [Formula]
recurse ladder [] used = []
recurse ladder vars used =  let result = loopLadder ladder (vars, used) in recurse ladder fst(result) (snd(result) ++ used)

loopLadder :: [Formula] -> ([Formula], [Formula]) -> ([Formula], [Formula])
loopLadder [] (vars, used) = ([], used)
loopLadder ladder ([], used) = ([], used)
loopLadder ((Iff v b) : xs) (vars, used) = if elem v vars then 
    let result = loopLadder xs ((delete v vars), (v:used)) in
    (extractDeps b (v:used) ++ fst result , snd result) else loopLadder xs (vars, used) 


extractDeps :: Formula -> [Formula] -> [Formula]
extractDeps (And a b) used = (extractDeps a used) ++ (extractDeps b used)
extractDeps (Or a b) used = (extractDeps a used) ++ (extractDeps b used)
extractDeps (Not a) used = extractDeps a used
extractDeps (Iff a b) used = (extractDeps a used) ++ (extractDeps b used)
extractDeps (Var s n) used = if elem (Var s n) used then [] else [(Var s 1)]
extractDeps top used = []
