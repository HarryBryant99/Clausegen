---------------------------------------------------------------
--  
-- |
-- Module:       Safety
-- Maintainer:   cspj@swan.ac.uk
-- Stability:    provisional
-- Portability:  portable
-- defines safety conditions to be proven for epping, they 
-- should be thaught of as templates that are instantiated 
-- when given an integer that represents a the cycle count.
-- Please note this file is currently being upgraded to
-- perform iterations of the ladder.
---------------------------------------------------------------

module Safety(reservedlatches,readSafetyConditions, checkNewFormat, SafetyCond2) where


import Ladder
import Formula
import ConditionParser.ConditionParser
import ConditionParser.ConditionParserTokeniser(alexScanTokens)
import GcssParser.GcssParser


-- | Defines the initial state of all reserved latches for
-- Epping as a list.
reservedlatches :: VarMaps
reservedlatches = [("NOPCR",False,ReservedLatchV),
                   ("NVCSEL",True,ReservedLatchV),
                   ("0LOIC",False,ReservedLatchV),
                   ("1LOIC",False,ReservedLatchV),
                   ("2LOIC",False,ReservedLatchV),
                   ("3LOIC",False,ReservedLatchV),
                   ("4LOIC",False,ReservedLatchV),
                   ("5LOIC",False,ReservedLatchV),
                   ("6LOIC",False,ReservedLatchV),
                   ("7LOIC",False,ReservedLatchV),
                   ("0LOOC",False,ReservedLatchV),
                   ("1LOOC",False,ReservedLatchV),
                   ("2LOOC",False,ReservedLatchV),
                   ("3LOOC",False,ReservedLatchV),
                   ("4LOOC",False,ReservedLatchV),
                   ("5LOOC",False,ReservedLatchV),
                   ("6LOOC",False,ReservedLatchV),
                   ("7LOOC",False,ReservedLatchV),
                   ("EXOPCR",False,ReservedLatchV),
                   ("OPCRFLT",True,ReservedLatchV),
                   ("PIOFLT",True,ReservedLatchV),
                   ("RCOVER",False,ReservedLatchV),
                   ("MYMODE",False,ReservedLatchV),
                   ("SBYSTAT",False,ReservedLatchV),
                   ("SSWITCH",False,ReservedLatchV),
                   ("CONFLT",True,ReservedLatchV),
                   ("RESLATA",False,ReservedLatchV),
                   ("RESLATB",False,ReservedLatchV)]

-- | Defines that a safety condition
-- is a mapping from cycle count, i.e. 
-- integers to a formula representing
-- the safety condition after that many 
-- cycles
type SafetyCond = Int -> Formula


--instance Show SafetyCond where
--  show sc n = sc 0  

-- | New type added for Iterative approach.
-- Now a safety condsition is only a 
-- formula.
type SafetyCond2 = Formula

-- | A type to re an substitution, obviously they can be concatenated to
-- produce a complicated assignment that is built up over time.
type Substitution = Formula -> Formula

-- | Function combines two safety conditions, into
-- a single safety condition. Note this is new 
-- implementation for new safety condition format.
combinesafetyconds :: SafetyCond2 -> SafetyCond2 -> SafetyCond2
combinesafetyconds c1 c2 = (And (c1) (c2))

-- | Given a safety condition, a substitution and a formula
-- representing the ladder, returns a new formula representing 
-- the ladder with the safety condition not'ed.
appendsafetyconds :: SafetyCond2 -> Substitution -> Formula -> Formula
appendsafetyconds sc phi ladder = And ladder (Not (phi  sc))

-- | Given a ladder and a safety consitions file,
-- reads the safety conditions from the file using alex
-- to parse the file and return the tokens. Then constructs
-- a list of tuples representing the safety conditions.
readSafetyConditions :: Ladder -> String -> [SafetyCond]
readSafetyConditions l = (map f).conditions.alexScanTokens
                         where
                           f (s,c,sc) = (sc g)
                           g s n = if (isCoil l s) then (n+1) else (max n 0)

-- | Given a ladder and a coil name returns true
-- if the coil is in the ladder false if not.                           
isCoil :: Ladder -> String -> Bool
isCoil lad lt = (or.(map f).(map extractcells).extractrungs) lad
                where
                  f cells = case (extractcell (testcellbytype CellTypeCoil) cells) of
                              NoLadder -> False
                              (Cell _ _ _ name _) -> (lt == name)


checkNewFormat :: [Formula] -> Bool
checkNewFormat (x:xs) = if checkFormula x 
                        then True 
                        else checkNewFormat xs
checkNewFormat [] = False

checkFormula :: Formula -> Bool
checkFormula (Var s v) = elem '_' s





