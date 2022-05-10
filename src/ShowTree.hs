---------------------------------------------------------------
--  
-- |
-- Module:       ShowTree
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- 
-- A module for displaying tree like structures.
-- 
--------------------------------------------------------------

module ShowTree (
   Parcel,          -- instance of Show
   string2Parcel,   -- :: String -> Parcel
   binParcel,       -- :: String -> Parcel -> Parcel -> Parcel
   combineParcelsL, -- :: String -> [Parcel] -> Parcel
   combineParcelsR, -- :: String -> [Parcel] -> Parcel
   unaryParcel      -- :: String -> Parcel -> Parcel
  )
  where

-------------------------------------------------------------
-- 
-- Demo.
--
-- In order to understand what the exported functions do, 
-- it is best to try out the examples below.
-- It is not necessary to read the code.
--
-- Try:
--
-- print parcel0 
-- 
-- e.t.c.
--
-- The function print is predefined in Prelude.hs:
--
-- print     :: Show a => a -> IO ()
-- print xs = putStrLn (show xs)  
--
-- Examples
-- parcel0 = binParcel "+" (string2Parcel "x") (string2Parcel "7")
-- parcel1 = combineParcelsL "+" [string2Parcel (show n) | n <- [1..6]]
-- parcel2 = combineParcelsR "+" [string2Parcel (show n) | n <- [1..6]]
-- parcel3 = binParcel "*" parcel1 parcel2
-- parcel4 = binParcel "*" parcel2 parcel1
-- parcel5 = binParcel "+" parcel3 parcel4
--
-- For example:
--
-- Parcel> print parcel3
--
--                           *
--                      -------------
--                     |             |
--                     +             +
--                 ---------      --------
--                |         |    |        |
--                +         6    1        +
--            ---------                --------
--           |         |              |        |
--           +         5              2        +
--        --------                          -------
--       |        |                        |       |
--       +        4                        3       +
--    -------                                    ------
--   |       |                                  |      |
--   +       3                                  4      +
--  ----                                              ----
-- |    |                                            |    |
-- 1    2                                            5    6
--
--
-- Parcel> print parcel4
--
--                            *
--      ---------------------------------------------
--     |                                             |
--     +                                             +
--  --------                                     ---------
-- |        |                                   |         |
-- 1        +                                   +         6
--       --------                           ---------
--      |        |                         |         |
--      2        +                         +         5
--            -------                   --------
--           |       |                 |        |
--           3       +                 +        4
--                 ------           -------
--                |      |         |       |
--                4      +         +       3
--                      ----      ----
--                     |    |    |    |
--                     5    6    1    2
--
------------------------------------------------------


-- | A block is a nonempty list of strings of equal lengths.
type Block = [String]

-- | Gives Height of block. 
height :: Block -> Int
height  b = length b

-- | Gives Width of block.
width :: Block -> Int
width  b = length (head b)

-- | Gives block dimensions.
dimension :: Block -> (Int,Int)
dimension b = (width b, height b)

-- | A parcel, Parcel (h,b), is a block, b, with a handle 
-- (or hook), h, where 0 <= h < width b.
--
-- If, for example, b = ["aaaaaaa","bbbbbbb","ccccccc"] and h = 2,
-- then think of the parcel as
--
--    h
--  aaaaaaa
--  bbbbbbb
--  ccccccc
--
-- The position of the letter h indicates where we would
-- "hang up" the parcel to combine it with others.
newtype Parcel = Parcel (Int,Block)

-- | Show function for parcel
instance Show Parcel where
   show (Parcel (_,xss)) = concat ['\n':xs | xs <- xss] ++ "\n"

-- | Combining blocks horizontally
-- assuming height b1 = height b2.
hor :: Block -> Block -> Block
hor b1 b2 = zipWith (++) b1 b2 

-- | Combining blocks vertically
-- assuming width b1 = width b2.
ver :: Block -> Block -> Block
ver b1 b2 = b1 ++ b2            

-- | Combines a list of blocks horizontally.
hors :: [Block] -> Block
hors = foldl1 hor

-- | Combines a list of blocks vertically.
vers :: [Block] -> Block
vers = foldl1 ver

-- | Create a block with dimensions x by y,
-- the block is the filled with "c" values.
fill :: Char -> Int -> Int -> Block
fill c x y = replicate y (replicate x c)  

-- | Increases the vertical size of a block
-- to height y, filling the block with 
-- "c" values.
addVer :: Char -> Int -> Block -> Block
addVer c y b = ver b (fill c (width b) y)

-- | Creates a binary node like structure given two
-- parcels and a string, the two parcels are then
-- the left and right subtrees of node with label
-- given as string.
binParcel :: String -> Parcel -> Parcel -> Parcel
binParcel top (Parcel (hL,bL)) (Parcel (hR,bR))
  = Parcel (h,vers [b1,b2,b3,b4]) where
   xT      = length top + 2
   hT      = xT `div` 2 + 1
   (xL,yL) = dimension bL
   (xR,yR) = dimension bR
   y  = max yL yR
   h  = (hL + xL + hR) `div` 2 + 1
   x1 = hL - 1
   x2 = xL - hL + hR + 1
   x3 = xR - hR 
   x4 = h - hT + 1
   x5 = xL + xR + 3 - h + hT - xT
   bL1 = addVer ' ' (y-yL) bL
   bR1 = addVer ' ' (y-yR) bR
   b1  = hors [fill ' ' x4 1,[top],fill ' ' x5 1]
   b2  = hors [fill ' ' hL 1,fill '-' x2 1,fill ' ' (x3+1) 1]
   b3  = hors [fill ' ' x1 1,["|"],fill ' ' x2 1,["|"],fill ' ' x3 1]
   b4  = hors [bL1,fill ' ' 2 y,bR1]

-- | Creates a unary node like structure given a
-- parcels and a string, the parcels then subtrees 
-- of node with label given as string.
unaryParcel :: String -> Parcel -> Parcel
unaryParcel top (Parcel (h,b)) = Parcel (h,vers [b1,b2,b3]) 
  where
   xT = length top + 2
   hT = xT `div` 2 + 1
   (xb,yb) = dimension b
   x4 = h - hT + 1                          
   x5 = xb + 3 - h + hT - xT  
   x1 = h - 1                          
   x2 = xb + 2 - h   
   b1 = hors [fill ' ' x4 1,[top],fill ' ' x5 1]
   b2 = hors [fill ' ' x1 1,["|"],fill ' ' x2 1]
   b3 = hors [b,fill ' ' 2 yb]

-- | Given a string calculates where its hook should be
-- then creates a parcel representing the string.
string2Parcel :: String -> Parcel
string2Parcel xs = Parcel (h, [" " ++ xs ++ " "]) where
   h = (length xs + 2) `div` 2 + 1

-- | Creates a binary tree of parcels, labelling the nodes
-- with given string. Note creates full subtrees in left 
-- branches.
combineParcelsL :: String -> [Parcel] -> Parcel
combineParcelsL = foldl1 . binParcel

-- | Creates a binary tree of parcels, labelling the nodes
-- with given string. Note creates full subtrees in right 
-- branches.
combineParcelsR :: String -> [Parcel] -> Parcel
combineParcelsR = foldr1 . binParcel
