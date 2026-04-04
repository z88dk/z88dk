//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "lexer_keywords.h"
#include "options.h"
#include "pathnames.h"
#include "preproc.h"
#include "string_utils.h"

static const size_t BYTES_PER_LINE = 16;

//-----------------------------------------------------------------------------
// dispatch table for directives
//-----------------------------------------------------------------------------

std::unordered_map<Keyword, Preproc::DirectiveHandler>
Preproc::directive_handlers_ = {
    { Keyword::INCLUDE, &Preproc::process_INCLUDE },
    { Keyword::BINARY,  &Preproc::process_BINARY },
    { Keyword::INCBIN,  &Preproc::process_BINARY },
};

//-----------------------------------------------------------------------------
// directive handlers and helpers
//-----------------------------------------------------------------------------

void Preproc::check_end_of_line(const std::vector<Token>& input_line,
                                size_t& pos,
                                std::string_view directive_name) {
    while (pos < input_line.size() &&
            input_line[pos].type == TokenType::EndOfLine) {
        ++pos;
    }

    if (pos < input_line.size()) {
        g_diag.error(input_line[pos].loc,
                     "Unexpected token after " + std::string(directive_name) +
                     ": " + std::string(g_strings.view(input_line[pos].text_id)));
    }
}

bool Preproc::parse_filename(const std::vector<Token>& input_line,
                             size_t& pos,
                             std::string_view directive_name,
                             std::string& out_filename,
                             bool& out_is_angle_bracket,
                             SourceLoc& out_filename_loc) {
    if (pos >= input_line.size() || input_line[pos].type == TokenType::EndOfLine) {
        g_diag.error(input_line[pos].loc, "Expected filename after " +
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
        g_diag.error(input_line[pos].loc, "Expected filename after " +
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

// Common helper: parse filename, check end of line, resolve file path.
// Returns true on success with resolved path in out_resolved and location
// in out_filename_loc. Reports errors and returns false on failure.
bool Preproc::parse_and_resolve_file(const std::vector<Token>& input_line,
                                     size_t& pos,
                                     std::string_view directive_name,
                                     std::string& out_resolved,
                                     SourceLoc& out_filename_loc) {
    std::string filename;
    bool is_angle_bracket = false;
    if (!parse_filename(input_line, pos, directive_name,
                        filename, is_angle_bracket, out_filename_loc)) {
        return false;
    }

    check_end_of_line(input_line, pos, directive_name);

    std::string_view including_filename =
        include_stack.empty() ? "" :
        g_strings.view(include_stack.back().file->file_id);
    out_resolved = resolve_include_candidate(filename,
                   including_filename,
                   is_angle_bracket,
                   g_args.options.include_paths);
    if (out_resolved.empty()) {
        g_diag.error(out_filename_loc, "File not found: " + std::string(filename));
        return false;
    }

    return true;
}

void Preproc::process_INCLUDE(const std::vector<Token>& input_line,
                              size_t& pos) {
    std::string resolved;
    SourceLoc filename_loc;
    if (!parse_and_resolve_file(input_line, pos, "INCLUDE",
                                resolved, filename_loc)) {
        return;
    }

    // check for recursive inclusion
    StringInterner::Id resolved_id =
        g_file_mgr.register_virtual_file(resolved);
    for (const auto& frame : include_stack) {
        if (frame.file->file_id == resolved_id) {
            g_diag.error(filename_loc,
                         "Recursive inclusion of file: " + resolved);
            return;
        }
    }

    // push new include frame
    const SourceFile* included_file =
        g_file_mgr.get_source_file(resolved, filename_loc);
    if (!included_file) {
        // error already emitted by get_source_file()
        return;
    }

    include_stack.push_back({
        included_file,
        0,                  // current_line
        included_file->file_id, // logical_file_id
        1,                  // logical_line
    });

    dependency_files.push_back(included_file->file_id);
}

void Preproc::process_BINARY(const std::vector<Token>& input_line,
                             size_t& pos) {
    std::string resolved;
    SourceLoc filename_loc;
    if (!parse_and_resolve_file(input_line, pos, "BINARY",
                                resolved, filename_loc)) {
        return;
    }

    // read binary file (cached)
    const std::vector<uint8_t>* data =
        g_file_mgr.read_binary_file(resolved, filename_loc);
    if (!data) {
        return; // error already emitted by read_binary_file()
    }

    if (data->empty()) {
        return; // empty file, nothing to emit
    }

    // Emit tokens for binary data: one token per byte, with value = byte value
    for (size_t i = 0; i < data->size(); i += BYTES_PER_LINE) {
        LogicalLine line{ {}, filename_loc };
        line.tokens.reserve(1 + 2 * BYTES_PER_LINE + 1); // DEFB b1,...,bN <EOL>

        line.tokens.push_back(Token::identifier("DEFB", filename_loc));

        for (size_t j = 0; j < BYTES_PER_LINE && i + j < data->size(); ++j) {
            if (j > 0) {
                line.tokens.push_back(Token::token(TokenType::Comma, ",",
                                                   filename_loc));
            }

            int value = (*data)[i + j];
            line.tokens.push_back(Token::integer(std::to_string(value), value,
                                                 filename_loc));
        }

        line.tokens.push_back(Token::token(TokenType::EndOfLine, "\n",
                                           filename_loc));

        macro_work_queue.push_back(std::move(line));
    }

    // generate dependency for included file
    StringInterner::Id resolved_id =
        g_file_mgr.register_virtual_file(resolved);
    dependency_files.push_back(resolved_id);
}

//-----------------------------------------------------------------------------
// main driver for directive processing:
// classifies line and dispatches to handlers
//-----------------------------------------------------------------------------

Preproc::LineType Preproc::process_directive_line(
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
    bool cond_active = cond_stack.empty() ||
                       cond_stack.back().currently_active;

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
    // Non-conditional directives
    // ---------------------------------------------------------------------
    auto it = directive_handlers_.find(kw);
    if (it != directive_handlers_.end()) {
        (this->*it->second)(input_line, pos);
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
    g_diag.error(first.loc, "Unknown preprocessor directive");
    return LineType::ControlOnly;
}
