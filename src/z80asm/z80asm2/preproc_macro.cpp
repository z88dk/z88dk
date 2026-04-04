//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "lexer_tokens.h"
#include "preproc.h"
#include "string_interner.h"
#include <algorithm>
#include <vector>

static const int MAX_EXPANSION_DEPTH = 1000;

void Preproc::expand_line(const LogicalLine& in,
                          std::vector<Token>& out_tokens) {
    out_tokens.clear();

    // ---------------------------------------------------------------------
    // 1. Copy input tokens into working buffer
    // ---------------------------------------------------------------------
    std::vector<Token> work = in.tokens;

    // Expansion recursion tracking
    int expansion_depth = 0;
    std::vector<StringInterner::Id> expansion_stack;

    // ---------------------------------------------------------------------
    // 2. Main expansion loop
    // ---------------------------------------------------------------------
    while (true) {
        if (++expansion_depth > MAX_EXPANSION_DEPTH) {
            g_diag.error(in.loc, "Macro expansion limit exceeded");
            break;
        }

        bool expanded_any = false;

        // -------------------------------------------------------------
        // Scan tokens left-to-right
        // -------------------------------------------------------------
        for (size_t i = 0; i < work.size(); ++i) {
            Token& tok = work[i];

            // Only identifiers can be macro names
            if (tok.type != TokenType::Identifier) {
                continue;
            }

            StringInterner::Id name_id = tok.text_id;

            // Is this a macro?
            auto it = macros.find(name_id);
            if (it == macros.end()) {
                continue;
            }

            MacroBody& macro = it->second;

            // ---------------------------------------------------------
            // 2.1 Recursion prevention
            // ---------------------------------------------------------
            if (std::find(expansion_stack.begin(), expansion_stack.end(),
                          name_id)
                    != expansion_stack.end()) {
                // TODO: compat mode: skip; strict mode: error
                continue;
            }

            expansion_stack.push_back(name_id);

            // ---------------------------------------------------------
            // 2.2 Function-like macro
            // ---------------------------------------------------------
            if (macro.is_function_like) {
                // TODO:
                // - Check for '(' with no whitespace gap
                // - Parse argument list
                // - Substitute parameters
                // - Handle # and ##
                // - Replace invocation in 'work'
                expanded_any = true;
                expansion_stack.pop_back();
                break; // restart scanning
            }

            // ---------------------------------------------------------
            // 2.3 Classical multi-line macro
            // ---------------------------------------------------------
            if (macro.is_multiline) {
                // TODO:
                // - Only expand if identifier is in opcode position
                // - For each macro line:
                //       LogicalLine ll = ...
                //       If ll starts with directive:
                //           ctx.macro_work_queue.push_back(ll)
                //       else:
                //           ctx.macro_work_queue.push_back(ll)
                //
                // - Classical macros replace the entire line
                expansion_stack.pop_back();
                return; // done with this line
            }

            // ---------------------------------------------------------
            // 2.4 Object-like macro
            // ---------------------------------------------------------
            {
                // TODO:
                // - Replace identifier token with macro.tokens
                expanded_any = true;
                expansion_stack.pop_back();
                break; // restart scanning
            }
        }

        if (!expanded_any) {
            break;    // no more expansions possible
        }
    }

    // ---------------------------------------------------------------------
    // 3. Finalization: append expanded tokens + EndOfLine
    // ---------------------------------------------------------------------
    for (const Token& t : work) {
        out_tokens.push_back(t);
    }

    Token eol;
    eol.type = TokenType::EndOfLine;
    eol.loc = in.loc;
    out_tokens.push_back(eol);
}
