//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc_macro.h"

/* -------------------------------------------------------------------------
   Macro Expansion Flow (preproc_macro.cpp)
   -------------------------------------------------------------------------

   This file implements:

       void expand_line(
           PreprocessorContext& ctx,
           const LogicalLine& in,
           std::vector<Token>& out_tokens,
           deque<LogicalLine>& macro_work_queue
       );

   NEW: Classical macro expansion may emit directive lines. These are pushed
   into macro_work_queue and will be processed by the directive engine
   before normal macro expansion continues.

   -------------------------------------------------------------------------
   1. Setup
   -------------------------------------------------------------------------

   - work = in.tokens
   - expansion_depth = 0
   - expansion_stack = vector<Id>

   -------------------------------------------------------------------------
   2. Main Expansion Loop
   -------------------------------------------------------------------------

   while (true):

       if (++expansion_depth > MAX_EXPANSION_DEPTH):
           error("macro expansion limit exceeded");
           break;

       bool expanded_any = false;

       Scan 'work' left-to-right:

           If token is not Identifier -> continue
           If identifier not in ctx.macros -> continue

           const MacroBody& macro = ctx.macros[id]

           -----------------------------------------------------------------
           2.1 Recursion Prevention
           -----------------------------------------------------------------

           If id in expansion_stack:
               // Recursive macro call
               // compat: ignore
               // strict: error
               continue;

           Push id onto expansion_stack.

           -----------------------------------------------------------------
           2.2 Function-like Macros
           -----------------------------------------------------------------

           If macro.is_function_like:
               - Parse arguments
               - Substitute params
               - Apply # and ##
               - Replace invocation in 'work'
               - expanded_any = true
               - Pop id
               - break

           -----------------------------------------------------------------
           2.3 Classical Multi-line Macros
           -----------------------------------------------------------------

           If macro.is_multiline:

               - For each macro line:
                     LogicalLine ll = that line

                     If ll begins with directive keyword:
                         // Feedback loop
                         macro_work_queue.push_back(ll)
                     Else:
                         // Normal line to be expanded later
                         macro_work_queue.push_back(ll)

               - Pop id
               - Return immediately (classical macros replace whole line)

           -----------------------------------------------------------------
           2.4 Object-like Macros
           -----------------------------------------------------------------

           Else:
               - Replace identifier with macro.tokens
               - expanded_any = true
               - Pop id
               - break

       if (!expanded_any):
           break;

   -------------------------------------------------------------------------
   3. Finalization
   -------------------------------------------------------------------------

   - Append remaining tokens in 'work' to out_tokens.
   - Append EndOfLine token.

   -------------------------------------------------------------------------
   End of Macro Expansion Flow
   ------------------------------------------------------------------------- */

void expand_line(
    PreprocessorContext& ctx,
    const LogicalLine& in,
    std::vector<Token>& out_tokens) {
    (void)ctx;
    (void)in;
    (void)out_tokens;
}
