---------------------------------------------------------------
--  
-- |
-- Module:       Formula
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- Defines a data type and some operations to represent a
-- propositional boolean formula.
-- 
-------------------------------------------------------------

module Formula (
     Formula(..),
     removeiff,        -- :: Formula -> Formula 
     removeor,         -- :: Formula -> Formula
     newvars,          -- :: Formula -> Formula
     formulatree,      -- :: Formula -> Parcel
     extractVars2,  
    ) 
    where

-------------------------------------------------------------

import ShowTree
import qualified Data.Set as Set
import Data.List
import Data.Char

-- | Defines recursively the format of a Formula.
data Formula = And Formula Formula |
               Or Formula Formula  |
               Not Formula         |
               Iff Formula Formula |
               Var String Int      |
               Top
               deriving (Eq)

-- | Show function for a Formula.
instance Show Formula where
  show f = formulalist 0 f
  

-- | Consturcts a Parcel (i.e. tree) of a given Formula
-- nodes are labelled with And, Or, Not, Iff, True and 
-- subtress then represent sub formulae.
formulatree :: Formula -> Parcel
formulatree (And a b) = binParcel "and" (formulatree a) (formulatree b)
formulatree (Or a b) = binParcel "or" (formulatree a) (formulatree b)
formulatree (Not a) = unaryParcel "not" (formulatree a)
formulatree (Iff a b) = binParcel "iff" (formulatree a) (formulatree b)
formulatree (Var a v) = string2Parcel (a ++ " " ++ (show v))
formulatree Top = string2Parcel "True"

-- | Constructs a list representation of a formula, attaching _n to 
-- a variable and listing operations in prefix form.
formulalist :: Int -> Formula -> String
formulalist n (And a b) = (replicate n ' ') ++ "and\n" ++ (formulalist (n+1) a) ++ (formulalist (n+1) b)
formulalist n (Or a b) = (replicate n ' ') ++ "or\n" ++ (formulalist (n+1) a) ++ (formulalist (n+1) b)
formulalist n (Not a) = (replicate n ' ') ++ "not\n" ++ (formulalist (n+1) a)
formulalist n (Iff a b) = (replicate n ' ') ++ "iff\n" ++ (formulalist (n+1) a) ++ (formulalist (n+1) b)
formulalist n (Var a v) = (replicate n ' ') ++ a ++ "_" ++ (show v) ++ "\n"
formulalist n Top = (replicate n ' ') ++ "True\n"

-- | Uses rule A -> B = not A V B to replace any 
-- implications recursively.
removeiff :: Formula -> Formula
removeiff (Iff a b) = Or (And a b) (And (Not a) (Not b))
removeiff (And a b) = And (removeiff a) (removeiff b)
removeiff (Or a b) = Or (removeiff a) (removeiff b)
removeiff (Not a) = Not (removeiff a)
removeiff (Var a v) = Var a v
removeiff Top = Top

-- | Uses rule A V B = not (not A /\ not B) to replace any 
-- or formulae recursively.
removeor :: Formula -> Formula
removeor (Iff a b) = Iff (removeor a) (removeor b)
removeor (And a b) = And (removeor a) (removeor b)
removeor (Or a b) = Not (And (Not (removeor a)) (Not (removeor b)))
removeor (Not a) = Not (removeor a)
removeor (Var a v) = Var a v
removeor Top = Top

-- | Creates a clone of the formula entered but with all the versions on
-- the variables incremented.
newvars :: Formula -> Formula
newvars (And a b) = And (newvars a) (newvars b)
newvars (Or a b) = Or (newvars a) (newvars b)
newvars (Iff a b) = Iff (newvars a) (newvars b)
newvars (Not a) = Not (newvars a)
newvars Top = Top
newvars (Var s i) = Var s (i+1)


extractVars2 :: Formula -> [Formula]
extractVars2 (And a b) = (extractVars2 a) ++ (extractVars2 b)
extractVars2 (Or a b) = (extractVars2 a) ++ (extractVars2 b)
extractVars2 (Not a) = extractVars2 a
extractVars2 (Iff a b) = (extractVars2 a) ++ (extractVars2 b)
extractVars2 (Var s n) = [(Var s n)]
extractVars2 top = []








           
                                  











