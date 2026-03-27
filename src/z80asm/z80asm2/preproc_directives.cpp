//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer_keywords.h"
#include "preproc_directives.h"

/* -------------------------------------------------------------------------
   Directive Processing Flow (preproc_directives.cpp)
   -------------------------------------------------------------------------

   This file implements:

       LineType process_directive_line(
           PreprocessorContext& ctx,
           const std::vector<Token>& input_line,
           LogicalLine& out_line
       );

   Input lines may originate from:
       - Source files (via include_stack)
       - Macro expansion (via macro_work_queue)

   The directive engine remains purely line-oriented.

   -------------------------------------------------------------------------
   1. Initial Classification
   -------------------------------------------------------------------------

   - Identify first non-EndOfLine token.
   - If not a directive keyword:
         If current conditional block inactive -> Skip
         Else -> Normal
   - If directive keyword:
         Dispatch to directive handler.

   -------------------------------------------------------------------------
   2. Conditional Directives
   -------------------------------------------------------------------------

   IF / ELSEIF / ELSE / ENDIF
       - Update ctx.cond_stack.
       - Return ControlOnly.

   -------------------------------------------------------------------------
   3. Include Handling
   -------------------------------------------------------------------------

   INCLUDE "file" or <file>
       - Resolve filename.
       - Tokenize included file (cached).
       - Push new IncludeFrame.
       - Return ControlOnly.

   -------------------------------------------------------------------------
   4. Macro Definitions
   -------------------------------------------------------------------------

   DEFINE (object-like)
   DEFINE (function-like)
   MACRO ... ENDM (classical)
   UNDEF

       - Modify ctx.macros.
       - Return ControlOnly.

   NOTE:
       Classical macro definitions may appear inside macro expansions.
       This is supported and safe.

   -------------------------------------------------------------------------
   5. Line Number Rewriting
   -------------------------------------------------------------------------

   LINE / C_LINE
       - Update logical file/line mapping.
       - Return ControlOnly.

   -------------------------------------------------------------------------
   6. EQU and Preprocessor Symbols
   -------------------------------------------------------------------------

   name EQU <expr>
       - Evaluate expression.
       - Update ctx.pp_symbols.
       - Return ControlOnly.

   -------------------------------------------------------------------------
   7. Normal Lines
   -------------------------------------------------------------------------

   - If conditional inactive -> Skip.
   - Else:
         * Copy tokens into out_line
         * Apply logical file/line mapping
         * Return Normal.

   -------------------------------------------------------------------------
   End of Directive Processing Flow
   ------------------------------------------------------------------------- */

LineType process_directive_line(
    PreprocessorContext& ctx,
    const std::vector<Token>& input_line,
    LogicalLine& out_line) {
    out_line.tokens.clear();
    out_line.loc = input_line.empty() ? SourceLoc{} :
                   input_line[0].loc;

    // ---------------------------------------------------------------------
    // 1. Find first non-EndOfLine token
    // ---------------------------------------------------------------------
    size_t i = 0;
    while (i < input_line.size() && input_line[i].type == TokenType::EndOfLine) {
        ++i;
    }

    if (i >= input_line.size()) {
        // Empty line -> normal line (macro expander will append EOL)
        return LineType::Normal;
    }

    const Token& first = input_line[i];

    // ---------------------------------------------------------------------
    // 2. If inside inactive conditional block, only IF/ELSEIF/ELSE/ENDIF run
    // ---------------------------------------------------------------------
    bool cond_active = ctx.cond_stack.empty() || ctx.cond_stack.back().currently_active;

    // ---------------------------------------------------------------------
    // 3. If first token is not an identifier -> normal line
    // ---------------------------------------------------------------------
    if (first.type != TokenType::Identifier) {
        if (!cond_active) {
            return LineType::Skip;
        }

        out_line.tokens = input_line;   // copy as-is
        return LineType::Normal;
    }

    Keyword kw = first.keyword;

    if (!keyword_is_preproc_directive(kw)) {
        // Not a directive keyword
        if (!cond_active) {
            return LineType::Skip;
        }

        out_line.tokens = input_line;
        return LineType::Normal;
    }

    // ---------------------------------------------------------------------
    // 4. Dispatch to directive handlers
    // ---------------------------------------------------------------------

    // -------------------------
    // IF
    // -------------------------
    if (kw == Keyword::IF) {   // TODO: define Keyword::IF
        // TODO: parse expression tokens
        // TODO: call eval_const_expr()
        // TODO: push ConditionalFrame with if_loc = first.loc
        return LineType::ControlOnly;
    }

    // -------------------------
    // ELSEIF
    // -------------------------
    if (kw == Keyword::ELSEIF) {
        // TODO: validate ctx.cond_stack not empty
        // TODO: evaluate expression
        // TODO: update ConditionalFrame
        return LineType::ControlOnly;
    }

    // -------------------------
    // ELSE
    // -------------------------
    if (kw == Keyword::ELSE) {
        // TODO: validate ctx.cond_stack not empty
        // TODO: update ConditionalFrame
        return LineType::ControlOnly;
    }

    // -------------------------
    // ENDIF
    // -------------------------
    if (kw == Keyword::ENDIF) {
        // TODO: validate ctx.cond_stack not empty
        // TODO: pop
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // If conditional block inactive, ignore all other directives
    // ---------------------------------------------------------------------
    if (!cond_active) {
        return LineType::Skip;
    }

    // ---------------------------------------------------------------------
    // INCLUDE
    // ---------------------------------------------------------------------
    if (kw == Keyword::INCLUDE) {
        // TODO: parse filename
        // TODO: resolve include
        // TODO: push IncludeFrame
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // DEFINE (object-like or function-like)
    // ---------------------------------------------------------------------
    if (kw == Keyword::DEFINE) {
        // TODO: parse name + replacement tokens
        // TODO: update ctx.macros
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // UNDEF
    // ---------------------------------------------------------------------
    if (kw == Keyword::UNDEF) {
        // TODO: parse name
        // TODO: ctx.macros.erase(name)
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // Classical MACRO ... ENDM
    // ---------------------------------------------------------------------
    if (kw == Keyword::MACRO) {
        // TODO: parse macro header
        // TODO: read lines until ENDM (driver handles EOF)
        // TODO: store in ctx.macros
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // LINE / C_LINE
    // ---------------------------------------------------------------------
    if (kw == Keyword::LINE || kw == Keyword::C_LINE) {
        // TODO: parse filename + line number
        // TODO: update ctx.include_stack.back().logical_file_id / logical_line
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // EQU
    // ---------------------------------------------------------------------
    if (kw == Keyword::EQU) {
        // TODO: parse name
        // TODO: parse expression
        // TODO: eval_const_expr()
        // TODO: ctx.const_symbols.set(name_id, value, first.loc)
        return LineType::ControlOnly;
    }

    // ---------------------------------------------------------------------
    // Unknown directive -> error
    // ---------------------------------------------------------------------
    error(first.loc, "Unknown preprocessor directive");
    return LineType::ControlOnly;
}
