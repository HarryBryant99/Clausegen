
{
module ConditionParser.ConditionParser (conditions) where

import ConditionParser.ConditionParserTokeniser
import Formula

}

%name conditions
%tokentype { ConditionParserTokens }
%token
  and               { ConditionParser.ConditionParserTokeniser.And }
  or                { ConditionParser.ConditionParserTokeniser.Or }
  negation          { ConditionParser.ConditionParserTokeniser.Not }
  implication       { ConditionParser.ConditionParserTokeniser.Implication }
  equivalence       { ConditionParser.ConditionParserTokeniser.Equivalence }
  conditionname     { ConditionParser.ConditionParserTokeniser.Name $$ }
  comment           { ConditionParser.ConditionParserTokeniser.Comment $$ }
  lbrace            { ConditionParser.ConditionParserTokeniser.LBrace }
  rbrace            { ConditionParser.ConditionParserTokeniser.RBrace }
  literal           { ConditionParser.ConditionParserTokeniser.Literal $$ }

%left equivalence
%left implication
%left and
%left or
%left negation

%%

Grammar : Conditions                                        { reverse $1 }

Conditions : {- empty -}                                    { []::[Condition] }
           | Conditions Condition                           { $2:$1 }

Condition : Name ConditionTail                              { ($1,fst $2,snd $2) }

ConditionTail : Comment Formula                             { ($1,$2) }
              | Formula                                     { ("",$1) }

Name : conditionname                                        { $1 }

Comment : comment                                           { $1 }

Formula : Formula and Formula                               { (\f x->Formula.And ($1 f x) ($3 f x)) }
        | Formula or Formula                                { (\f x->Formula.Or ($1 f x) ($3 f x)) }
        | Formula implication Formula                       { (\f x->Formula.Or (Formula.Not ($1 f x)) ($3 f x)) }
        | Formula equivalence Formula                       { (\f x->Formula.Iff ($1 f x) ($3 f x)) }
        | lbrace Formula rbrace                             { $2 }
        | negation Formula                                  { (\f x->Formula.Not ($2 f x)) }
        | literal                                           { (\f x->Formula.Var $1 (f $1 x)) }

{
-- this tuple represents a safety condition, the first element is
-- the name of the safety condition. The second is an optional comment 
-- and the third is the acutual formula of the condition. 
-- the first function provides a mapping between the name
-- of a literal to a number, typically n or n+1 depending if it the literal
-- in question is a coil but these decision can not be made at this level
-- as it requires more information so is defurred until later.
type Condition = (String,String,((String -> Int -> Int) -> Int -> Formula))

happyError :: [ConditionParserTokens] -> a
happyError ts = error "Parse Error"

} 
