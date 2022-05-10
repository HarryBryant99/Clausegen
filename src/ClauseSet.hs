---------------------------------------------------------------
--  
-- |
-- Module:       ClausetSet
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- The module defines functions to construct a clause set, along
-- with some useful operations on clause sets. Here a clause
-- set is represented as a simple list.
-- 
---------------------------------------------------------------
module ClauseSet(
    dimacs,
    Var,
    Clause,
    ClauseSet,
    newclause,
    insertvar,
    newclauseset,
    insertclause,
    concatclauseset,
    dimacsclause,
    dimacslit
    ) 
    where

-- import List
-- import Char
import Data.Char
import Numeric

-- | Defines a variable as a pair
-- (variable name, boolean value).
type Var a = (a,Bool)

-- | Defines a clause as a list of variables. 
type Clause a = [Var a]

-- | Defines a clause set as a list of clauses.
type ClauseSet a = [Clause a]

-- | Function to create a new empty clause.
newclause :: Clause a
newclause = []

-- | Adds a variable to a clause, making sure the 
-- variable added is not duplicated.
insertvar :: (Eq a) => (Clause a) -> (Var a) -> (Clause a)
insertvar cl v = if (elem v cl) then cl else v:cl

-- | Creates a new empty Clauseset.
newclauseset :: ClauseSet a
newclauseset = []

-- | Adds a clause to a clasueset ensuring the cluase is not
-- duplicated.
insertclause :: (Eq a) => (ClauseSet a) -> (Clause a) -> (ClauseSet a)
insertclause cls cl = if (elem cl cls) then cls else cl:cls

-- | Combines the two given clausesets into a single clauseset.
-- Note that here we should check for duplicates, maybe use nub.
concatclauseset :: (Eq a) => (ClauseSet a) -> (ClauseSet a) -> (ClauseSet a)
concatclauseset c1 c2 = c1 ++ c2 


-- | Print the given clauseset in Dimacs format accepted
-- by most sat solvers .
dimacs :: (ClauseSet String) -> String
dimacs cls = "c starting cnf listing, generated according to Dr. Kullmann's cs-342 lecture script 9a for 2007/08\n" ++ (foldr (\x y->x++"\n"++y) "" (map dimacsclause cls)) ++ "\nc finished\n"

-- | Prints the given clause in dimacs format 
-- accepted by most sat solvers.
dimacsclause :: (Clause String) -> String
dimacsclause lts = foldr (\x y->x++" "++y) "0" (map dimacslit lts)

-- | Prints a literal, if the literal is negated then a 
-- minus (-) is shown before it
dimacslit :: (Var String) -> String
dimacslit (a,False) = consid a
dimacslit (a,True) = '-':(dimacslit (a,False))

-- | Constructs a representation of a character, 
-- currently works by converting the character
-- to ascii then to hex such that the resulting 
-- identifier is two characters long
chr2id :: Char -> String
--chr2id c = let x = (showHex (ord c) "")
--           in if (length x) == 1 then ('0':x) else x
chr2id c = let x = show (ord c)
               l = length x
           in if (l == 1) then (x ++ ['0'] ++ ['0']) else if (l == 2) then (x ++ ['0']) else x

-- | Converts a string into a hex string
consid :: String -> String
consid id = foldr (++) "" (map chr2id id)
--consid id = id
