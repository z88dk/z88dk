//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer_keywords.h"
#include "options.h"
#include "pathnames.h"
#include "preproc_directives.h"
#include "string_utils.h"

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

static void check_end_of_line(const std::vector<Token>& input_line,
                              size_t& pos,
                              std::string_view directive_name) {
    while (pos < input_line.size() &&
            input_line[pos].type == TokenType::EndOfLine) {
        ++pos;
    }

    if (pos < input_line.size()) {
        error(input_line[pos].loc,
              "Unexpected token after " + std::string(directive_name) +
              ": " + std::string(g_strings.view(input_line[pos].text_id)));
    }
}

static bool parse_filename(const std::vector<Token>& input_line,
                           size_t& pos,
                           std::string_view directive_name,
                           std::string& out_filename,
                           bool& out_is_angle_bracket,
                           SourceLoc& out_filename_loc) {
    if (pos >= input_line.size() || input_line[pos].type == TokenType::EndOfLine) {
        error(input_line[pos].loc, "Expected filename after " +
              std::string(directive_name));
        return false;
    }

    // accept "file" or <file>
    if (input_line[pos].type == TokenType::String) {
        out_filename =
            g_strings.view(input_line[pos].value.str_value_id);
        std::string_view quoted_filename =
            g_strings.view(input_line[pos].text_id);
        out_is_angle_bracket = !quoted_filename.empty() &&
                               quoted_filename.front() == '<' && quoted_filename.back() == '>';
        out_filename_loc = input_line[pos].loc;
        pos++;
        return true;
    }

    // accept sequence of tokens until a space
    std::string_view token_text = g_strings.view(input_line[pos].text_id);
    if (token_text.size() == 0 || is_space(token_text.front())) {
        error(input_line[pos].loc, "Expected filename after " +
              std::string(directive_name));
        return false;
    }

    out_is_angle_bracket = false;
    out_filename = token_text;
    out_filename_loc = input_line[pos].loc;
    size_t column = input_line[pos].loc.column + token_text.size();
    pos++;

    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine &&
            input_line[pos].loc.column == column) {
        token_text = g_strings.view(input_line[pos].text_id);
        out_filename += token_text;
        column = input_line[pos].loc.column + token_text.size();
        pos++;
    }

    return true;
}

static void process_INCLUDE(PreprocessorContext& ctx,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    // parse filename token
    std::string filename;
    bool is_angle_bracket = false;
    SourceLoc filename_loc;
    if (!parse_filename(input_line, pos, "INCLUDE",
                        filename, is_angle_bracket, filename_loc)) {
        return; // error already emitted by parse_filename()
    }

    check_end_of_line(input_line, pos, "INCLUDE");

    // search for file
    std::string_view including_filename =
        ctx.include_stack.empty() ? "" :
        g_strings.view(ctx.include_stack.back().logical_file_id);
    std::string resolved = resolve_include_candidate(filename,
                           including_filename,
                           is_angle_bracket,
                           g_args.options.include_paths);
    if (resolved.empty()) {
        error(filename_loc, "File not found: " + std::string(filename));
        return;
    }

    // check for recursive inclusion
    StringInterner::Id resolved_id = register_virtual_file(resolved);
    for (const auto& frame : ctx.include_stack) {
        if (frame.logical_file_id == resolved_id) {
            error(filename_loc,
                  "Recursive inclusion of file: " + std::string(filename));
            return;
        }
    }

    // push new include frame
    const SourceFile* included_file = get_source_file(resolved, filename_loc);
    if (!included_file) {
        // error already emitted by get_source_file()
        return;
    }

    ctx.include_stack.push_back({
        included_file,
        0,                  // current_line
        resolved_id,        // logical_file_id
        1                   // logical_line
    });
}

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
    size_t pos = 0;
    while (pos < input_line.size() &&
            input_line[pos].type == TokenType::EndOfLine) {
        ++pos;
    }

    if (pos >= input_line.size()) {
        // Empty line -> normal line (macro expander will append EOL)
        return LineType::Normal;
    }

    const Token& first = input_line[pos];
    ++pos;

    // ---------------------------------------------------------------------
    // 2. If inside inactive conditional block, only IF/ELSEIF/ELSE/ENDIF run
    // ---------------------------------------------------------------------
    bool cond_active = ctx.cond_stack.empty() ||
                       ctx.cond_stack.back().currently_active;

    // ---------------------------------------------------------------------
    // 3. Check if first token is a directive keyword (possibly after #)
    // ---------------------------------------------------------------------
    Keyword kw = first.keyword;

    if (first.type == TokenType::Hash && pos < input_line.size() &&
            input_line[pos].type == TokenType::Identifier) {
        kw = input_line[pos].keyword;
        ++pos;
    }

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
        process_INCLUDE(ctx, input_line, pos);
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
