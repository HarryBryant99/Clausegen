
{
module ConditionParser.ConditionParserTokeniser (ConditionParserTokens(..),alexScanTokens) where

--import Prelude hiding (Either(..))
}

%wrapper "basic"

$graphic    = $printable # $white

@litstring =  \" ($graphic # \")* \"
@namestring =  \[ ($graphic # \])* \]
@comment =  \# ([\x00-\xff] # \#)* \#

tokens :-

$white+                                    ;
@namestring                                { \s -> Name (reverse (tail (reverse (tail s)))) }
@litstring                                 { \s -> Literal (reverse (tail (reverse (tail s)))) }
@comment                                   { \s -> Comment (reverse (tail (reverse (tail s)))) }
&                                          { \s -> And }
\|                                         { \s -> Or }
\~                                         { \s -> Not }
\-\>                                       { \s -> Implication }
\<\-\>                                     { \s -> Equivalence }
\(                                         { \s -> LBrace }
\)                                         { \s -> RBrace }

{

data ConditionParserTokens =
  And               |
  Or                |
  Not               |
  Implication       |
  Equivalence       |
  Name String       |
  Comment String    |
  LBrace            |
  RBrace            |
  Literal String
  deriving (Eq,Show)
}
