---------------------------------------------------------------
--  
-- |
-- Module:       FormulaTree
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- The module takes a formula and constructs a formula tree of it,
-- a tree that has many nodes to each operation other than being 
-- limited to two.
-- 
-- constructformulatree performs the whole translation
-- constructstage2 finalises the tree and can be called after
-- the tree has been modified to restore integrity. It removes
-- duplicate literals, removes clashing literals
-- and removes nodes with only one child 
-- 
---------------------------------------------------------------

module FormulaTree(
    FormulaTree(..),
    constructformulatree, -- :: FormulaTree -> FormulaTree
    constructstage2,      -- :: FormulaTree -> FormulaTree
    children,             -- :: FormulaTree -> [FormulaTree]
    negateformulatree,    -- :: FormulaTree -> FormulaTree
    t1                    -- :: Formula (test formula)
    ) 
    where

import Formula hiding (formulatree)
import Data.List
import ShowTree

-- | Internal representation of a formula, pushed
-- formula represents a formula with negations 
-- pushed to the literals. 
-- The Bool in Lit has meaning False indicates not
-- negated. 
data PushedFormula =  And PushedFormula PushedFormula
                    | Or PushedFormula PushedFormula               
                    | Iff PushedFormula PushedFormula              
                    | Lit String Int Bool              
                    | Top                                          
                    | Bottom
                      deriving (Eq)

-- | Show function for a pushed formula
instance Show PushedFormula where
  show f = show (formulatree f)

-- | Recursively construct a tree representing the given
-- pushed formula.
formulatree :: PushedFormula -> Parcel
formulatree (FormulaTree.And a b) = binParcel "and" (formulatree a) (formulatree b)
formulatree (FormulaTree.Or a b) = binParcel "or" (formulatree a) (formulatree b)
formulatree (FormulaTree.Iff a b) = binParcel "iff" (formulatree a) (formulatree b)
formulatree (FormulaTree.Lit s i False) = string2Parcel (s ++ " " ++ (show i))
formulatree (FormulaTree.Lit s i True) = unaryParcel "not" (formulatree (FormulaTree.Lit s i False))
formulatree FormulaTree.Top = string2Parcel "True"
formulatree FormulaTree.Bottom = string2Parcel "False"

-- | The type of formula tree that is exported.
data FormulaTree =  Conjunction [FormulaTree]
                  | Disjunction [FormulaTree]
                  | Equivalence [FormulaTree]
                  | Const Bool               
                  | Literal String Int Bool
                    deriving (Eq)

-- | Show fnction for external formula tree
instance Show FormulaTree where
  show f = formulalist 0 f

-- | Produces a list representation of a formula, n is the number of spaces
-- to use as an indentation. The number of spaces between an operator and its
-- operand will then be 2*n. 
formulalist :: Int -> FormulaTree -> String
formulalist n (Const b) = (replicate (2*n) ' ') ++ (show b) ++ "\n"
formulalist n (Literal s i False) = (replicate (2*n) ' ') ++ s ++ " " ++ (show i) ++ "\n"
formulalist n (Literal s i True) = formulalist n (Literal ('~':s) i False)
formulalist n (Conjunction fs) = (replicate (2*n) ' ') ++ "and\n" ++ (foldl (\x y-> x ++ y) "" (map (formulalist (n+1)) fs))
formulalist n (Disjunction fs) = (replicate (2*n) ' ') ++ "or\n" ++ (foldl (\x y-> x ++ y) "" (map (formulalist (n+1)) fs))
formulalist n (Equivalence fs) = (replicate (2*n) ' ') ++ "iff\n" ++ (foldl (\x y-> x ++ y) "" (map (formulalist (n+1)) fs))

-- Some test functions
t1 = Not (Formula.Iff (Formula.Or (Formula.And (Var "y" 0) (Formula.And (Not (Var "y" 0)) (Formula.Iff (Formula.Or (Var "x" 0) (Formula.Or (Formula.Or (Var "z" 0) (Var "z" 0)) (Formula.Or (Var "e" 0) (Var "f" 0)))) (Formula.Or (Var "z" 0) (Var "z" 0))))) (Not (Not (Var "x" 0)))) (Not (Formula.And (Formula.Top) (Not Formula.Top))))
t2 = pushnegation t1
t3 = removeconstants t2
t4 = buildtree t3
t5 = flattentree t4
t6 = consistancycheck (removerepeates t5)

-- | Uses basic de-morgan laws to push any negations to the literals.
-- Notice th use of a boolean value with literals.
pushnegation :: Formula -> PushedFormula
pushnegation (Not (Formula.Or a b)) = FormulaTree.And (pushnegation (Not a)) (pushnegation (Not b))
pushnegation (Not (Formula.And a b)) = FormulaTree.Or (pushnegation (Not a)) (pushnegation (Not b))
pushnegation (Not (Formula.Iff a b)) = FormulaTree.Iff (pushnegation (Not a)) (pushnegation b)
pushnegation (Not (Not a)) = pushnegation a
pushnegation (Not (Var s i)) = Lit s i True
pushnegation (Not (Formula.Top)) = Bottom
pushnegation (Formula.Or a b) = FormulaTree.Or (pushnegation a) (pushnegation b)
pushnegation (Formula.And a b) = FormulaTree.And (pushnegation a) (pushnegation b)
pushnegation (Formula.Iff a b) = FormulaTree.Iff (pushnegation a) (pushnegation b)
pushnegation (Var s i) = Lit s i False
pushnegation (Formula.Top) = FormulaTree.Top

-- | Returns the negated version of a given formula.
negateformula :: PushedFormula -> PushedFormula
negateformula (FormulaTree.And a b) = FormulaTree.Or (negateformula a) (negateformula b)
negateformula (FormulaTree.Or a b) = FormulaTree.And (negateformula a) (negateformula b)
negateformula (FormulaTree.Iff a b) = FormulaTree.Iff (negateformula a) b
negateformula (Lit s i b) = (Lit s i (not b))
negateformula FormulaTree.Top = Bottom
negateformula Bottom = FormulaTree.Top

-- | Applies basic boolean laws to factor out true and false values from 
-- the given pushed formula, returning a simplified pushed formula.
removeconstants :: PushedFormula -> PushedFormula
removeconstants Bottom = Bottom
removeconstants FormulaTree.Top = FormulaTree.Top
removeconstants (FormulaTree.And a Bottom) = Bottom
removeconstants (FormulaTree.And Bottom a) = Bottom
removeconstants (FormulaTree.And FormulaTree.Top a) = removeconstants a
removeconstants (FormulaTree.And a FormulaTree.Top) = removeconstants a
removeconstants (FormulaTree.And a b) = let a' = removeconstants a
                                            b' = removeconstants b
                                        in if ((a' /= a) || (b' /= b))
                                        then removeconstants (FormulaTree.And a' b')
                                        else (FormulaTree.And a b)
removeconstants (FormulaTree.Or a Bottom) = removeconstants a
removeconstants (FormulaTree.Or Bottom a) = removeconstants a
removeconstants (FormulaTree.Or FormulaTree.Top a) = FormulaTree.Top
removeconstants (FormulaTree.Or a FormulaTree.Top) = FormulaTree.Top
removeconstants (FormulaTree.Or a b) = let a' = removeconstants a
                                           b' = removeconstants b
                                       in if ((a' /= a) || (b' /= b))
                                       then removeconstants (FormulaTree.Or a' b')
                                       else (FormulaTree.Or a b)
removeconstants (FormulaTree.Iff a Bottom) = removeconstants (negateformula a)
removeconstants (FormulaTree.Iff Bottom a) = removeconstants (negateformula a)
removeconstants (FormulaTree.Iff FormulaTree.Top a) = removeconstants a
removeconstants (FormulaTree.Iff a FormulaTree.Top) = removeconstants a
removeconstants (FormulaTree.Iff a b) = let a' = removeconstants a
                                            b' = removeconstants b
                                        in if ((a' /= a) || (b' /= b))
                                        then removeconstants (FormulaTree.Iff a' b')
                                        else (FormulaTree.Iff a b)
removeconstants (Lit s i b) = Lit s i b

-- | Given a pushed formula, builds a formula tree representing this 
-- formula. Note that we can handle more than two operands per node.
buildtree :: PushedFormula -> FormulaTree
buildtree FormulaTree.Top = Const True
buildtree Bottom = Const False
buildtree (FormulaTree.And a b) = Conjunction [buildtree a,buildtree b]
buildtree (FormulaTree.Or a b) = Disjunction [buildtree a,buildtree b]
buildtree (FormulaTree.Iff a b) = Equivalence [buildtree a,buildtree b]
buildtree (Lit s i b) = Literal s i b

-- | Recursive function that flattens nodes of the same type within
-- the tree, to a single node with many operands. 
flattentree :: FormulaTree -> FormulaTree
flattentree (Conjunction fs) = Conjunction (conjunctlist fs)
flattentree (Disjunction fs) = Disjunction (disjunctlist fs)
flattentree (Equivalence fs) = Equivalence (equivlist fs)
flattentree x = x

-- | Creates a list of formula trees representing all conjunctions that 
-- can be combined to a single conjunction with many subtrees.
conjunctlist :: [FormulaTree] -> [FormulaTree]
conjunctlist ((Conjunction fs1):fs2) = (conjunctlist fs1) ++ (conjunctlist fs2)
conjunctlist (f:fs2) = (flattentree f):(conjunctlist fs2)
conjunctlist [] = []

-- | Creates a list of formula trees representing all disjunctions that 
-- can be combined to a single disjunction with many subtrees.
disjunctlist :: [FormulaTree] -> [FormulaTree]
disjunctlist ((Disjunction fs1):fs2) = (disjunctlist fs1) ++ (disjunctlist fs2)
disjunctlist (f:fs2) = (flattentree f):(disjunctlist fs2)
disjunctlist [] = []

-- | Creates a list of formula trees representing all equivalence operations
-- that can be combined to a single equivalence node with many subtrees.
equivlist :: [FormulaTree] -> [FormulaTree]
equivlist ((Equivalence fs1):fs2) = (equivlist fs1) ++ (equivlist fs2)
equivlist (f:fs2) = (flattentree f):(equivlist fs2)
equivlist [] = []

-- | Given a formula tree, removerepeates removes repeated literals from 
-- the formula tree, making use of the nub function which removes duplicates
-- from a list.
removerepeates :: FormulaTree -> FormulaTree
removerepeates (Conjunction fs) = Conjunction (nub (map removerepeates fs))
removerepeates (Disjunction fs) = Disjunction (nub (map removerepeates fs))
removerepeates (Equivalence fs) = Equivalence (nub (map removerepeates fs))
removerepeates x = x

-- | Given a formula tree, looks for any clashing literals within
-- the formula tree. If a clashing literal is found, then either true
-- or false is returned depending on the boolean operation the 
-- clashing literal is an operand of.
removeclashes :: FormulaTree -> FormulaTree
removeclashes (Conjunction fs) = if (clashes fs) then (Const False)
                                 else Conjunction (map removeclashes fs)
removeclashes (Disjunction fs) = if (clashes fs) then (Const True)
                                 else Disjunction (map removeclashes fs)
removeclashes (Equivalence fs) = Equivalence (map removeclashes fs)
-- disabled the clashes check for equivalences as it doesnt seem correct
-- removeclashes (Equivalence fs) = if (clashes fs) then (Const False)
--                                 else Equivalence (map removeclashes fs)
removeclashes x = x

-- | Given a list of formula trees, detects if a clashing literal 
-- occurs within the list, returning a boolean representing the
-- result.
clashes :: [FormulaTree] -> Bool
clashes fs = any g fs
             where
               g f = if (isliteral f) 
                     then (any (==(negateliteral f)) (filter isliteral fs))
                     else False

-- | Tests whether or not the given formula tree 
-- represents a literal or not.
isliteral :: FormulaTree -> Bool
isliteral (Literal s i b) = True
isliteral _ = False

-- | Given a formula tree representing a literal,
-- returns a new formula tree representing the negated
-- literal.
negateliteral :: FormulaTree -> FormulaTree
negateliteral (Literal s i b) = (Literal s i (not b))


-- | Checks the given formula tree to see if there are any nodes
-- with a single child. If so this node can be replaced by its child.
consistancycheck :: FormulaTree -> FormulaTree
consistancycheck (Conjunction [x]) = consistancycheck x
consistancycheck (Disjunction [x]) = consistancycheck x
consistancycheck (Equivalence [x]) = consistancycheck x
consistancycheck (Conjunction (x:xs)) = Conjunction (map consistancycheck (x:xs))
consistancycheck (Disjunction (x:xs)) = Disjunction (map consistancycheck (x:xs))
consistancycheck (Equivalence (x:xs)) = Equivalence (map consistancycheck (x:xs))
consistancycheck (Const b) = Const b
consistancycheck (Literal s i b) = Literal s i b

-- | Given a formula tree, constructs a list of children
-- of the root node of the given formula tree. 
children :: FormulaTree -> [FormulaTree]
children (Conjunction fs) = fs
children (Disjunction fs) = fs
children (Equivalence fs) = fs
children _ = []

-- | Uses demorgans laws to negate a complete formula
-- tree, returning the negated tree as a result.
negateformulatree :: FormulaTree -> FormulaTree
negateformulatree (Conjunction fs) = Disjunction (map negateformulatree fs)
negateformulatree (Disjunction fs) = Conjunction (map negateformulatree fs)
negateformulatree (Equivalence (f:fs)) = Equivalence ((negateformulatree f):fs) 
negateformulatree (Literal s i b) = (Literal s i (not b))
negateformulatree (Const b) = Const (not b)

-- | Given a formula tree, the function uses demorgans laws to remove any
-- true or false values from within the tree. Returning a new reduced
-- formula tree.
rmconstants :: FormulaTree -> FormulaTree
rmconstants (Const b) = Const b
rmconstants (Literal s i b) = Literal s i b
rmconstants (Conjunction fs) = let fs' = filter (/=(Const True)) (map rmconstants fs)
                               in if (any (==(Const False)) fs')
                                  then (Const False)
                                  else if (fs' /= fs) 
                                       then rmconstants (Conjunction fs')
                                       else (Conjunction fs')
rmconstants (Disjunction fs) = let fs' = filter (/=(Const False)) (map rmconstants fs)
                               in if (any (==(Const True)) fs')
                                  then (Const True)
                                  else if (fs' /= fs) 
                                       then rmconstants (Disjunction fs')
                                       else (Disjunction fs')
rmconstants (Equivalence fs) = let fs' = (map rmconstants fs)
                               in if (any (==(Const True)) fs') && (any (==(Const False)) fs')
                                  then (Const False)
                                  else if (any (==(Const True)) fs')
                                       then Conjunction (filter (/=(Const True)) fs')
                                       else if (any (==(Const False)) fs')
                                            then Conjunction (map negateformulatree (filter (/=(Const False)) fs'))
                                            else if (fs' /= fs) 
                                                 then rmconstants (Equivalence fs')
                                                 else (Equivalence fs')

-- | Main function that translates a given formula into a formula tree.
-- To do this is performa a series of steps, firstly any negations are pushed
-- to the literals, then any true or false values are removed from the tree. 
-- Next a formula tree is constructed representing the formula. The constructed
-- tree is then flattened, so that operation nodes may have many children. 
-- Finally constructstage2 is called to finalize the tree.
constructformulatree :: Formula -> FormulaTree
constructformulatree = constructstage2 . flattentree . buildtree . removeconstants . pushnegation 

-- | Recursively removes repeated literals, clashingliterals and constants from the 
-- given formula tree. This process continues until the tree can no longer be improved. 
constructstage2 :: FormulaTree -> FormulaTree
constructstage2 t = let f = consistancycheck . rmconstants . removeclashes . removerepeates
                        t' = f t
                    in if (t == t') 
                       then t
                       else constructstage2 t'



