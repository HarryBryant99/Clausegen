---------------------------------------------------------------
--  
-- |
-- Module:       CNF
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- The module defines functions to construct a cnf representation.
-- of a formula.
-- 
---------------------------------------------------------------
module CNF(
    FormulaTree(..),
    tautree,
    cnf
    ) 
    where

import FormulaTree
import ClauseSet

-- | Data type to represent a basic tree.
data Node = Node String [Node] |
            Const Bool
            deriving (Eq,Show)

-- | Given a Formula tree and a node we wish to find name of, returns
-- the unique name of the node.
-- Note: Here there is a bug when more than 9 children, two trees
-- can map to the same variable.
findname :: FormulaTree -> (FormulaTree,String) -> String
findname f1 (f2,prefix) = if (f1 == f2)
                          then prefix
                          else (foldr (++) "" (map (\(x,y)->findname y (f2,prefix ++ (show x) ++ "i")) (zip [1..] (children f1))))

-- | Produces a literal used in the translation from a node, the first formula tree is the
-- whole structure and the second is the node we want to name. The string is a prefix for
-- the node name.
mkliteral :: FormulaTree -> String -> FormulaTree -> FormulaTree
mkliteral formula prefix t = Literal (findname formula (t,prefix)) 0 False

-- | Computes a formula tree by calling tautree2,
-- It makes the first node a conjunction node. 
tautree :: FormulaTree -> FormulaTree
tautree ft = Conjunction ((Literal "r" 0 False):(tautree2 ft "r" ft))

-- | Given a formula tree representing our main formula, and a string
-- enabling recursion on subtrees, and another formula tree representing 
-- the current node, computes a list of formula trees representing the new 
-- expanded formula.
tautree2 :: FormulaTree -> String -> FormulaTree -> [FormulaTree]
tautree2 formula p (Conjunction fts) = 
    [Equivalence [mkliteral formula p (Conjunction fts),Conjunction (map (mkliteral formula p) fts)]] ++ (concat (map (tautree2 formula p) fts))
tautree2 formula p (Disjunction fts) = 
    [Equivalence [mkliteral formula p (Disjunction fts),Disjunction (map (mkliteral formula p) fts)]] ++ (concat (map (tautree2 formula p) fts))
tautree2 formula p (Equivalence fts) = 
    [Equivalence [mkliteral formula p (Equivalence fts),Equivalence (map (mkliteral formula p) fts)]] ++ (concat (map (tautree2 formula p) fts))
tautree2 formula p (Literal s i b) = 
    [Equivalence [mkliteral formula p (Literal s i b),Literal s i b]]

-- | Given a formula, returns the formula in cnf form
basiccnf :: FormulaTree -> ClauseSet String
basiccnf (Literal s i b) = buildclauseset [buildclause [(Literal s i b)]]
basiccnf (Equivalence [Literal s i b,ft]) = basiccnf2 (Literal s i b) ft

-- | Auxillary function used to convert a formula into its cnf form.
-- Deals with each type of node independantly, returning a string in cnf form.
basiccnf2 :: FormulaTree -> FormulaTree -> ClauseSet String
basiccnf2 lit (Conjunction operands) = buildclauseset ((buildclause (lit:(map negateformulatree operands))):(map (f lit) operands))
                                       where f l o = buildclause [negateformulatree l,o]
basiccnf2 lit (Disjunction operands) = buildclauseset ((buildclause ((negateformulatree lit):operands)):(map (f lit) operands))
                                       where f l o = buildclause [l,negateformulatree o]
basiccnf2 c (Equivalence [b,a]) =
    buildclauseset [buildclause [a,b,c], buildclause [a, negateformulatree b, negateformulatree c], 
    buildclause [negateformulatree a, b, negateformulatree c], buildclause [negateformulatree a, negateformulatree b, c]]
basiccnf2 (Literal s i b) (Equivalence operands) = foldl concatclauseset newclauseset (map basiccnf (tautree2 equivchain s equivchain))
                                                   where f a b = Equivalence [a,b]
                                                         equivchain = foldr f (Literal s i b) operands
basiccnf2 a b = buildclauseset [buildclause [negateformulatree a,b],buildclause [negateformulatree b,a]]

-- | Given a list of literals, represented as a list of formula trees, 
-- constructs a clause out of the literals.
-- Note: Anything but a literal will cause a pattern match error.
buildclause :: [FormulaTree] -> Clause String
buildclause fts = foldl insertvar newclause (map (\(Literal s i b) -> (s ++ "_" ++ (show i),b)) fts)

-- | Given a list of Clauses, combines them to create
-- a clauset.
buildclauseset :: [Clause String] -> ClauseSet String
buildclauseset cs = foldl insertclause newclauseset cs

-- | Top level function for constructing the cnf formulas.
-- Given a formula tree will construct a Clauseset string out of it.
-- To do this firstly converts the formula to cnf form using tautree,
-- then combines the new formula to obtain a clauset which is then 
-- returned.
cnf :: FormulaTree -> ClauseSet String
cnf ft = foldl concatclauseset newclauseset (map basiccnf ((\(Conjunction clauses)->clauses)(tautree ft)))


