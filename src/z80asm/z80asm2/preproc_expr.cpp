//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc_expr.h"

/* -------------------------------------------------------------------------
   Preprocessor Expression Evaluation Flow (preproc_expr.cpp)
   -------------------------------------------------------------------------

   This file implements:

       bool eval_const_expr(
           PreprocessorContext& ctx,
           const std::vector<Token>& expr_tokens,
           int& result
       );

   The expression evaluator is a small, self-contained subsystem used by:
       - IF / ELSEIF directives
       - EQU constant definitions
       - Preprocessor symbol tests
       - Any directive requiring integer evaluation

   It supports:
       - Integer literals
       - Floating-point literals (converted to int)
       - Identifiers (preprocessor symbols)
       - Unary operators: +  -  !  ~
       - Binary operators:
             +  -  *  /  %
             <<  >>
             &  |  ^
             &&  ||
             **  (power)
             ^^  (logical XOR)
       - Comparison operators: ==  !=  <  <=  >  >=
       - Ternary operator:  condition ? expr1 : expr2
       - Parentheses
       - Undefined identifiers -> value 0
       - Host-width integer arithmetic (int)

   It does NOT support:
       - Labels
       - Relocatable expressions
       - CPU-dependent semantics
       - String literals
       - Macro expansion (already done earlier)

   -------------------------------------------------------------------------
   1. Token Filtering
   -------------------------------------------------------------------------

   - Remove EndOfLine tokens.
   - Convert floating-point literals to int (truncate).
   - Validate that all tokens are valid in expressions.
   - If invalid token encountered -> error() and return false.

   -------------------------------------------------------------------------
   2. Identifier Resolution
   -------------------------------------------------------------------------

   For each Identifier token:
       - Look up token.text_id in ctx.pp_symbols.
       - If found:
             replace token with integer literal token.
       - If not found:
             treat as value 0.

   -------------------------------------------------------------------------
   3. Parsing Strategy (Recursive Descent or Pratt)
   -------------------------------------------------------------------------

   Operator precedence (highest -> lowest):

       1.  primary
       2.  unary: +  -  !  ~
       3.  power: **        (right-associative)
       4.  multiplicative: *  /  %
       5.  additive: +  -
       6.  shift: <<  >>
       7.  relational: <  <=  >  >=
       8.  equality: ==  !=
       9.  bitwise AND: &
       10. bitwise XOR: ^
       11. bitwise OR: |
       12. logical XOR: ^^
       13. logical AND: &&
       14. logical OR: ||
       15. ternary: ? :    (right-associative)

   Grammar sketch:

       expr        -> ternary
       ternary     -> logical_or [ "?" expr ":" expr ]
       logical_or  -> logical_xor { "||" logical_xor }
       logical_xor -> logical_and { "^^" logical_and }
       logical_and -> bit_or     { "&&" bit_or }
       bit_or      -> bit_xor    { "|" bit_xor }
       bit_xor     -> bit_and    { "^" bit_and }
       bit_and     -> equality   { "&" equality }
       equality    -> relational { ("==" | "!=") relational }
       relational  -> shift      { ("<" | "<=" | ">" | ">=") shift }
       shift       -> additive   { ("<<" | ">>") additive }
       additive    -> multiplicative { ("+" | "-") multiplicative }
       multiplicative -> power   { ("*" | "/" | "%") power }
       power       -> unary { "**" unary }   // right-associative
       unary       -> ("+" | "-" | "!" | "~") unary
                   | primary
       primary     -> integer_literal
                   | "(" expr ")"

   -------------------------------------------------------------------------
   4. Evaluation
   -------------------------------------------------------------------------

   - All operations produce int results.
   - Floating-point inputs were already truncated.
   - Power operator (**) implemented as integer exponentiation.
   - Logical operators use short-circuit evaluation.
   - Division by zero -> error() and return false.

   -------------------------------------------------------------------------
   5. Result Handling
   -------------------------------------------------------------------------

   - On success:
         result = computed_value
         return true

   - On error:
         error(loc, "invalid expression")
         result = 0
         return false

   -------------------------------------------------------------------------
   6. Usage Notes
   -------------------------------------------------------------------------

   - IFDEF / IFNDEF do NOT use this evaluator.
   - EQU uses eval_const_expr() to compute constant values.
   - IF / ELSEIF use eval_const_expr() to determine truthiness:
         0 -> false
         nonzero -> true

   -------------------------------------------------------------------------
   End of Preprocessor Expression Evaluation Flow
   ------------------------------------------------------------------------- */
