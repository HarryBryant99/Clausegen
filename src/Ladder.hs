---------------------------------------------------------------
--  
-- |
-- Module:       Ladder
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- 
-- Defines the data type used to represent the ladder, it is simple
-- but has lots of operations to help
-- All ladders start with a root and a list of rungs. each rung 
-- has an indentifier and a list of cells. the cells are used
-- to represent the components of the ladder logic diagram.
-- A module for displaying tree like structures.
-- 
--------------------------------------------------------------

module Ladder (
    Ladder(..),      -- Ladder data type
    CellType(..),    -- CellType data type
    CellLinks(..),   -- CellLinks data type
    showLadder,      -- Instance of show
    extractrung,     -- :: Int -> [Ladder] -> Ladder
    extractrungs,    -- :: Ladder -> [Ladder]
    printrung,       -- :: Int -> [Ladder] -> IO ()
    extractcell,     -- :: (Ladder -> Bool) -> [Ladder] -> Ladder
    extractcells,    -- :: Ladder -> [Ladder]
    testcellbytype,  -- :: CellType -> Ladder -> Bool
    testcellbyposn,  -- :: Int -> Int -> Ladder -> Bool
    cellname,        -- :: Ladder -> String
    celllinks,       -- :: Ladder -> [CellLinks]
    celltype         -- :: Ladder -> CellType
    ) 
    where

import Data.List

-- | Data type for ladder.
data Ladder =  Root [Ladder]                                   
             | Rung Int [Ladder]                             
             | Cell Int Int CellType String [CellLinks]      
             | NoLadder
               deriving Eq

-- | Data type for a cell type of the ladder.
data CellType =  CellTypeCoil                                
               | CellTypeHorizontal_Shunt                    
               | CellTypeNormally_Open                       
               | CellTypeNormally_Closed                     
               | CellTypeEmpty                               
               | CellTypeEnd_Contact
                 deriving Eq
                
-- | Data type describing links between cells.
data CellLinks =  LinkTop                                    
                | LinkLeft                                   
                | LinkBottom                                 
                | LinkNone
                 deriving Eq
                 
-- | Show instance for Ladder.
instance Show Ladder where
  show NoLadder = "Nothing"
  show (Root rungs) = showLadder rungs
  show (Rung num cells) = "Rung " ++ (show num) ++ "\n" ++ (showLadder cells)
  show (Cell x y t name lnks) = "(" ++ (show x) ++ "," ++ (show y) ++ ") - " ++ 
                                      (show t) ++ " " ++ (show name) ++ " " ++ 
                                      (show lnks)

-- | Function used to show a ladder.
showLadder :: [Ladder] -> String
showLadder (r:rs) = (show r) ++ "\n" ++ (showLadder rs)
showLadder [] = "\n"
          
-- | Show instance for cell type.       
instance Show CellType where
  show CellTypeCoil = "Coil"
  show CellTypeHorizontal_Shunt = "Horizontal Shunt"
  show CellTypeNormally_Open = "Normally Open"
  show CellTypeNormally_Closed = "Normally Closed"
  show CellTypeEmpty = "Empty"
  show CellTypeEnd_Contact = "End Contact"

-- | Show instance for cell links.
instance Show CellLinks where
  show LinkTop = "Top"
  show LinkLeft = "Left"
  show LinkBottom = "Bottom"
  show LinkNone = "None"

-- | Given a ladder returns a list of ladders representing
-- the rungs of the given ladder.
extractrungs :: Ladder -> [Ladder]
extractrungs (Root rs) = (reverse . (drop 1) . reverse) rs
extractrungs _ = []

-- | Given a list of ladders representing rungs, returns
-- the rung numbered with the given integer.
extractrung :: Int -> [Ladder] -> Ladder
extractrung n ((Rung m cs):rs) = if n == m then (Rung m cs) else (extractrung n rs)
extractrung n [] = NoLadder

-- | Given a list of ladders representing rungs,
-- prints the rung numbered with the given integer,
-- if one exists.
printrung :: Int -> [Ladder] -> IO ()
printrung n (r:rs) = print (extractrung n (r:rs))
printrung n [] = print "rung not found"

-- | Given a Ladder, extracts a list of cells
-- from the ladder and returns these.
extractcells :: Ladder -> [Ladder]
extractcells (Rung _ cs) = cs
extractcells _ = []

-- | Given a mapping from ladder to boolean, and a
-- list of rungs, returns the cell if it exists.
extractcell :: (Ladder -> Bool) -> [Ladder] -> Ladder
extractcell test cs = let m = (find test cs) in
                        if m == Nothing then NoLadder else (\(Just a)->a)m                        

-- | Given a ladder and a cell type returns a
-- boolean value depending on whether or not 
-- the type of the given ladder is the same 
-- as the given cell type.
testcellbytype :: CellType -> Ladder -> Bool
testcellbytype ct1 (Cell _ _ ct2 _ _) = ct1 == ct2
testcellbytype _ _ = False

-- | Given two integers representing cooridinates,
-- and a cell, tests whether the cell is at the
-- position given by the coordinates. 
testcellbyposn :: Int -> Int -> Ladder -> Bool
testcellbyposn x1 y1 (Cell x2 y2 _ _ _) = x1 == x2 && y1 == y2
testcellbyposn _ _ _ = False

-- | Returns the name of given cell.
cellname :: Ladder -> String
cellname (Cell _ _ _ n _) = n
cellname _ = ""

-- | Returns a list of links from given cell.
celllinks :: Ladder -> [CellLinks]
celllinks (Cell _ _ _ _ lnks) = lnks
celllinks _ = []

-- | Returns the cell type for given cell.
celltype :: Ladder -> CellType
celltype (Cell _ _ t _ _) = t
