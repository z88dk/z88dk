//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_expr.h"
#include "const_symbols.h"
#include "diag.h"
#include "file_mgr.h"
#include "lexer.h"
#include "lexer_keywords.h"
#include "options.h"
#include "pathnames.h"
#include "preproc.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <algorithm>
#include <deque>
#include <unordered_map>
#include <utility>
#include <vector>

static const size_t BYTES_PER_LINE = 16;

//-----------------------------------------------------------------------------
// dispatch table for directives
//-----------------------------------------------------------------------------

std::unordered_map<Keyword, Preproc::DirectiveHandler>
Preproc::directive_handlers_ = {
    { Keyword::INCLUDE,    &Preproc::process_INCLUDE },
    { Keyword::BINARY,     &Preproc::process_BINARY },
    { Keyword::INCBIN,     &Preproc::process_BINARY },
    { Keyword::PRAGMA,     &Preproc::process_PRAGMA },
    { Keyword::ASSERT,     &Preproc::process_ASSERT },
    { Keyword::ERROR,      &Preproc::process_ERROR },
    { Keyword::LINE,       &Preproc::process_LINE },
    { Keyword::C_LINE,     &Preproc::process_C_LINE },
    { Keyword::DEFINE,     &Preproc::process_DEFINE },
    { Keyword::UNDEF,      &Preproc::process_UNDEF },
    { Keyword::UNDEFINE,   &Preproc::process_UNDEF },
    { Keyword::DEFL,       &Preproc::process_DEFL },
    { Keyword::MACRO,      &Preproc::process_MACRO },
    { Keyword::ENDM,       &Preproc::process_ENDM },
    { Keyword::LOCAL,      &Preproc::process_LOCAL },
    { Keyword::REPT,       &Preproc::process_REPT },
    { Keyword::REPTI,      &Preproc::process_REPTI },
    { Keyword::REPTC,      &Preproc::process_REPTC },
    { Keyword::ENDR,       &Preproc::process_ENDR },
    { Keyword::EXITM,      &Preproc::process_EXITM },
    { Keyword::IF,         &Preproc::process_IF },
    { Keyword::ELSEIF,     &Preproc::process_ELSEIF },
    { Keyword::ELIF,       &Preproc::process_ELSEIF },
    { Keyword::ELSE,       &Preproc::process_ELSE },
    { Keyword::ENDIF,      &Preproc::process_ENDIF },
    { Keyword::IFDEF,      &Preproc::process_IFDEF },
    { Keyword::IFNDEF,     &Preproc::process_IFNDEF },
    { Keyword::ELSEIFDEF,  &Preproc::process_ELSEIFDEF },
    { Keyword::ELSEIFNDEF, &Preproc::process_ELSEIFNDEF },
    { Keyword::ELIFDEF,    &Preproc::process_ELSEIFDEF },
    { Keyword::ELIFNDEF,   &Preproc::process_ELSEIFNDEF },
};

std::unordered_map<Keyword, Preproc::NameDirectiveHandler>
Preproc::name_directive_handlers_ = {
    { Keyword::DEFINE,   &Preproc::process_name_DEFINE },
    { Keyword::UNDEF,    &Preproc::process_name_UNDEF },
    { Keyword::UNDEFINE, &Preproc::process_name_UNDEF },
    { Keyword::DEFL,     &Preproc::process_name_DEFL },
    { Keyword::MACRO,    &Preproc::process_name_MACRO },
    { Keyword::LOCAL,    &Preproc::process_name_LOCAL },
    { Keyword::REPTI,    &Preproc::process_name_REPTI },
    { Keyword::REPTC,    &Preproc::process_name_REPTC },
};

//-----------------------------------------------------------------------------
// directive handlers and helpers
//-----------------------------------------------------------------------------

bool Preproc::is_directive(const std::vector<Token>& input_line,
                           size_t& pos,
                           Keyword& out_kw,
                           SourceLoc& out_kw_loc,
                           StringInterner::Id& out_name_id,
                           SourceLoc& out_name_loc) {
    out_kw = Keyword::None;
    out_kw_loc.clear();
    out_name_id = 0;
    out_name_loc.clear();

    // DIRECTIVE
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::Identifier &&
            keyword_is_preproc_directive(input_line[pos].keyword)) {
        out_kw = input_line[pos].keyword;
        out_kw_loc = input_line[pos].loc;
        pos++; // consume directive keyword
        return true;
    }

    // # DIRECTIVE
    if (pos + 1 < input_line.size() &&
            input_line[pos].type == TokenType::Hash &&
            input_line[pos + 1].type == TokenType::Identifier &&
            keyword_is_preproc_directive(input_line[pos + 1].keyword)) {
        out_kw = input_line[pos + 1].keyword;
        out_kw_loc = input_line[pos + 1].loc;
        pos += 2; // consume '#' and directive keyword
        return true;
    }

    // # LINE_NUMBER
    if (pos + 1 < input_line.size() &&
            input_line[pos].type == TokenType::Hash &&
            input_line[pos + 1].type == TokenType::Integer) {
        out_kw = Keyword::LINE;
        out_kw_loc = input_line[pos].loc;
        pos++; // consume '#'
        return true;
    }

    // name DIRECTIVE
    if (pos + 1 < input_line.size() &&
            input_line[pos].type == TokenType::Identifier &&
            input_line[pos + 1].type == TokenType::Identifier &&
            keyword_is_preproc_name_directive(input_line[pos + 1].keyword)) {
        out_kw = input_line[pos + 1].keyword;
        out_kw_loc = input_line[pos + 1].loc;
        out_name_id = input_line[pos].text_id;
        out_name_loc = input_line[pos].loc;
        pos += 2; // consume name and directive keyword
        return true;
    }

    return false;
}

bool Preproc::check_end_of_line(const std::vector<Token>& input_line,
                                size_t& pos,
                                Keyword kw) {
    while (pos < input_line.size() &&
            input_line[pos].type == TokenType::EndOfLine) {
        ++pos;
    }

    if (pos < input_line.size()) {
        g_diag.error(input_line[pos].loc,
                     "Unexpected token after " +
                     keyword_to_string(kw) +
                     ": " + g_strings.to_string(input_line[pos].text_id));
        return false;
    }

    return true;
}

bool Preproc::parse_filename(const std::vector<Token>& input_line,
                             size_t& pos,
                             Keyword kw,
                             std::string& out_filename,
                             bool& out_is_angle_bracket,
                             SourceLoc& out_filename_loc) {
    if (pos >= input_line.size() ||
            input_line[pos].type == TokenType::EndOfLine) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected filename after " +
                     keyword_to_string(kw));
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
                     keyword_to_string(kw));
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

    if (!out_filename.empty() &&
            out_filename.front() == '<' && out_filename.back() == '>') {
        out_is_angle_bracket = true;
        out_filename = out_filename.substr(1, out_filename.size() - 2);
    }

    if (!out_filename.empty() &&
            out_filename.front() == '"' && out_filename.back() == '"') {
        out_is_angle_bracket = false;
        out_filename = out_filename.substr(1, out_filename.size() - 2);
    }

    return true;
}

// Common helper: parse filename, check end of line, resolve file path.
// Returns true on success with resolved path in out_resolved and location
// in out_filename_loc. Reports errors and returns false on failure.
bool Preproc::parse_and_resolve_file(const std::vector<Token>& input_line,
                                     size_t& pos,
                                     Keyword kw,
                                     std::string& out_resolved,
                                     SourceLoc& out_filename_loc) {
    std::string filename;
    bool is_angle_bracket = false;
    if (!parse_filename(input_line, pos, kw,
                        filename, is_angle_bracket, out_filename_loc)) {
        return false;
    }

    if (!check_end_of_line(input_line, pos, kw)) {
        return false;   // error already reported
    }

    std::string_view including_filename =
        include_stack.empty() ? "" :
        g_strings.view(include_stack.back().file->file_id);
    out_resolved =
        resolve_include_candidate(filename,
                                  including_filename,
                                  is_angle_bracket,
                                  g_args.options.include_paths);
    if (out_resolved.empty()) {
        g_diag.error(out_filename_loc, "File not found: " + std::string(filename));
        return false;
    }

    return true;
}

bool Preproc::parse_LINE_args(const std::vector<Token>& input_line,
                              size_t& pos,
                              Keyword kw,
                              size_t& out_linenum,
                              std::string& out_filename) {
    out_linenum = 0;
    out_filename.clear();

    // accept line number
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Integer) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected line number after " +
                     keyword_to_string(kw));
        return false;
    }

    out_linenum = static_cast<size_t>(input_line[pos].value.int_value);
    pos++;

    // skip optional comma
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::Comma) {
        pos++;
    }

    if (pos >= input_line.size() ||
            input_line[pos].type == TokenType::EndOfLine) {
        return true;    // no filename, but that's fine
    }

    // accept optional filename
    std::string_view token_text = g_strings.view(input_line[pos].text_id);
    if (!token_text.empty() && !is_space(token_text.front())) {
        bool is_angle_bracket = false;
        SourceLoc filename_loc;
        if (!parse_filename(input_line, pos, kw,
                            out_filename, is_angle_bracket, filename_loc)) {
            return false;   // error already reported by parse_filename()
        }

        // try to resolve the filename against include paths
        std::string_view including_filename =
            include_stack.empty() ? "" :
            g_strings.view(include_stack.back().file->file_id);
        std::string resolved = resolve_include_candidate(
                                   out_filename,
                                   including_filename,
                                   is_angle_bracket,
                                   g_args.options.include_paths);
        if (!resolved.empty()) {
            out_filename = resolved;
        }
    }

    // cpp outputs other parameters after the filename, but we ignore them.
    return true;
}

bool Preproc::parse_params(const std::vector<Token>& input_line,
                           size_t& pos,
                           std::vector<StringInterner::Id>& out_params,
                           bool& out_has_parens) {
    out_params.clear();
    out_has_parens = false;

    // Helper: report failure with a message and clear out_params
    auto fail = [&](std::string_view message) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc, message);
        out_params.clear();
        return false;
    };

    // Helper: add a parameter name ensuring duplicates inside the same
    // list are rejected
    auto add_param = [&](StringInterner::Id name_id) -> bool {
        if (std::find(out_params.begin(), out_params.end(), name_id) !=
                out_params.end()) {
            return fail("Parameter redefined: " +
                        g_strings.to_string(name_id));
        }
        out_params.push_back(name_id);
        return true;
    };

    // Optional opening parenthesis
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::LeftParen) {
        out_has_parens = true;
        pos++; // consume '('

        // Empty list "()"
        if (pos < input_line.size() &&
                input_line[pos].type == TokenType::RightParen) {
            pos++;
            return true;
        }

        // If right after '(' we don't have an identifier, it's a syntax error
        if (pos >= input_line.size() ||
                input_line[pos].type != TokenType::Identifier) {
            return fail("Identifier expected");
        }
    }

    // If not in parens and next token is not an identifier, treat as empty list
    if (!out_has_parens) {
        if (pos >= input_line.size() ||
                input_line[pos].type != TokenType::Identifier) {
            // Empty parameter list without parentheses;
            // success with index unchanged
            return true;
        }
    }

    // Parse first identifier
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::Identifier) {
        if (!add_param(input_line[pos].text_id)) {
            return false;
        }
        pos++;
    }
    else {
        // Guard: should not happen due to checks above
        return fail("Identifier expected");
    }

    // Parse subsequent ", identifier" pairs
    while (pos < input_line.size() &&
            input_line[pos].type == TokenType::Comma) {
        pos++; // skip comma
        if (pos < input_line.size() &&
                input_line[pos].type == TokenType::Identifier) {
            if (!add_param(input_line[pos].text_id)) {
                return false;
            }
            pos++;
        }
        else {
            return fail("Identifier expected");
        }
    }

    // If we started with '(', we must end with ')'
    if (out_has_parens) {
        if (pos < input_line.size() &&
                input_line[pos].type == TokenType::RightParen) {
            pos++;
        }
        else {
            return fail("Right parenthesis or comma expected");
        }
    }

    return true;
}

bool Preproc::read_macro_body(Keyword start_kw,
                              const SourceLoc& start_kw_loc,
                              std::vector<LogicalLine>& out_lines,
                              std::vector<StringInterner::Id>& out_locals) {
    out_lines.clear();
    out_locals.clear();

    // Stack of open block structures. Each entry is the keyword that
    // opened the block, used to match against the corresponding closing
    // keyword and to produce clear error messages on mismatch.
    std::vector<std::pair<Keyword, SourceLoc>> nesting_stack;
    nesting_stack.push_back({ start_kw, start_kw_loc });

    LogicalLine line;
    while (next_logical_line(line)) {
        Keyword kw;
        SourceLoc kw_loc;
        StringInterner::Id name_id;
        SourceLoc name_loc;
        size_t pos = 0;

        if (is_directive(line.tokens, pos, kw, kw_loc, name_id, name_loc)) {
            // Opening keywords: push onto nesting stack
            if (kw == Keyword::MACRO ||
                    kw == Keyword::REPT ||
                    kw == Keyword::REPTC ||
                    kw == Keyword::REPTI) {
                nesting_stack.push_back({ kw, kw_loc });
            }
            // Closing keywords: validate and pop
            else if (kw == Keyword::ENDM || kw == Keyword::ENDR) {
                if (!check_end_of_line(line.tokens, pos, kw)) {
                    return false;
                }

                if (nesting_stack.empty()) {
                    g_diag.error(kw_loc,
                                 "Unexpected " +
                                 keyword_to_string(kw) +
                                 " directive");
                    return false;
                }

                Keyword open_kw = nesting_stack.back().first;
                SourceLoc open_loc = nesting_stack.back().second;

                // Validate matching: MACRO<->ENDM, REPT/REPTC/REPTI<->ENDR
                bool matched = false;
                if (kw == Keyword::ENDM) {
                    matched = (open_kw == Keyword::MACRO);
                }
                else if (kw == Keyword::ENDR) {
                    matched = (open_kw == Keyword::REPT ||
                               open_kw == Keyword::REPTC ||
                               open_kw == Keyword::REPTI);
                }

                if (!matched) {
                    g_diag.error(kw_loc,
                                 keyword_to_string(kw) +
                                 " does not match " +
                                 keyword_to_string(open_kw));
                    g_diag.note(open_loc, keyword_to_string(open_kw) +
                                " defined here");
                    return false;
                }

                nesting_stack.pop_back();

                // If we've closed the outermost block, we're done
                if (nesting_stack.empty()) {
                    return true;
                }
            }
            // LOCAL directive: only process at the outermost nesting level
            else if (kw == Keyword::LOCAL && nesting_stack.size() == 1) {
                // "label1 LOCAL" syntax: name was parsed by is_directive
                if (name_id != 0) {
                    if (std::find(out_locals.begin(), out_locals.end(), name_id) ==
                            out_locals.end()) {
                        out_locals.push_back(name_id);
                    }
                }

                // "LOCAL label1, label2, ..." syntax: parse identifier list
                std::vector<StringInterner::Id> params;
                bool has_parens = false;
                if (!parse_params(line.tokens, pos, params, has_parens)) {
                    return false; // error already reported
                }

                for (StringInterner::Id id : params) {
                    if (std::find(out_locals.begin(), out_locals.end(), id) ==
                            out_locals.end()) {
                        out_locals.push_back(id);
                    }
                }

                if (!check_end_of_line(line.tokens, pos, kw)) {
                    return false;
                }

                // LOCAL lines are consumed; do NOT add to out_lines
                continue;
            }
        }

        out_lines.push_back(std::move(line));
    }

    // Reached EOF without closing all blocks
    auto& top = nesting_stack.back();
    g_diag.error(top.second,
                 "Unexpected end of file, missing " +
                 keyword_to_string(top.first == Keyword::MACRO ?
                                   Keyword::ENDM : Keyword::ENDR) +
                 " for " + keyword_to_string(top.first));
    return false;
}

bool Preproc::eval_if_expr(const std::vector<Token>& input_line,
                           size_t& pos, Keyword kw) {
    // the rest of the line is the expression to evaluate
    std::vector<Token> expr_tokens;
    expr_tokens.reserve(input_line.size() - pos);
    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine) {
        expr_tokens.push_back(input_line[pos]);
        pos++;
    }

    if (expr_tokens.empty()) {
        g_diag.error(input_line.back().loc, "Expected expression after " +
                     keyword_to_string(kw) + " directive");
        return false;
    }

    // Expand macros in expression
    LogicalLine line(expr_tokens.front().loc);
    line.tokens = std::move(expr_tokens);
    std::vector<Token> expanded;
    expand_line(line, expanded);

    if (expanded.empty()) {
        g_diag.error(input_line.back().loc, "Expected expression after " +
                     keyword_to_string(kw) + " directive");
        return false;
    }

    // evaluate the if condition
    size_t expr_pos = 0;
    int result = 0;
    if (!eval_if_condition(expanded, expr_pos,
                           const_symbols, result, /*silent=*/false)) {
        // error already reported by eval_const_expr
        return false;
    }

    if (expr_pos >= expanded.size() ||
            expanded[expr_pos].type != TokenType::EndOfLine) {
        g_diag.error(input_line.back().loc, "Expected expression after " +
                     keyword_to_string(kw) + " directive");
        return false;
    }

    return static_cast<bool>(result);
}

bool Preproc::eval_ifdef_name(const std::vector<Token>& input_line,
                              size_t& pos,
                              bool negated,
                              Keyword kw) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " + keyword_to_string(kw));
        return false;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    pos++;

    if (!check_end_of_line(input_line, pos, kw)) {
        return false;   // error already reported
    }

    // check the macros
    bool is_def = macros.find(name_id) != macros.end();
    if (!is_def) {
        // also check symbol table
        is_def = const_symbols.symbols.find(name_id) != const_symbols.symbols.end();
    }

    bool cond = negated ? !is_def : is_def;
    return cond;
}

void Preproc::parse_asm_definitions(const std::vector<Token>& tokens) {
    bool have_definition = false;
    StringInterner::Id name_id = 0;
    SourceLoc name_loc;
    size_t pos = 0;

    // (DEFC|EQU) name [=] expr
    if (pos + 2 < tokens.size() &&
            (tokens[0].keyword == Keyword::DEFC ||
             tokens[0].keyword == Keyword::EQU) &&
            tokens[1].type == TokenType::Identifier) {
        have_definition = true;
        name_id = tokens[1].text_id;
        name_loc = tokens[1].loc;
        pos = 2;
    }
    // name (DEFC|EQU) [=] expr
    else if (pos + 2 < tokens.size() &&
             tokens[0].type == TokenType::Identifier &&
             (tokens[1].keyword == Keyword::DEFC ||
              tokens[1].keyword == Keyword::EQU)) {
        have_definition = true;
        name_id = tokens[0].text_id;
        name_loc = tokens[0].loc;
        pos = 2;
    }
    // name = expr
    else if (pos + 2 < tokens.size() &&
             tokens[0].type == TokenType::Identifier &&
             tokens[1].type == TokenType::EQ) {
        have_definition = true;
        name_id = tokens[0].text_id;
        name_loc = tokens[0].loc;
        pos = 1;    // '=' will be skipped in next step
    }

    if (!have_definition) {
        return; // not a definition line
    }

    // scan optional '='
    if (pos < tokens.size() &&
            tokens[pos].type == TokenType::EQ) {
        pos++; // skip '='
    }

    if (pos >= tokens.size() || tokens[pos].type == TokenType::EndOfLine) {
        return; // no expression, nothing to evaluate
    }

    // macros are already expanded at this point, so we only expect
    // constant expressions. Try to evaluate the expression and if it
    // succeeds, store in const_symbols for use in future expressions.
    int result = 0;
    if (eval_const_expr(tokens, pos,
                        const_symbols, result, /*silent=*/true) &&
            pos < tokens.size() &&
            tokens[pos].type == TokenType::EndOfLine) {
        const_symbols.set(name_id, result, name_loc);
    }
}

void Preproc::rewrite_logical_line(LogicalLine& line) {
    if (include_stack.empty()) {
        return;
    }

    IncludeFrame& frame = include_stack.back();
    if (!frame.logical_line_fixed && frame.logical_line_offset == 0) {
        return; // no change needed
    }

    {
        SourceLine physical_loc(line.loc);
        if (frame.logical_line_fixed) {
            line.loc.line = static_cast<uint32_t>(frame.logical_line_offset);
        }
        else {
            line.loc.line += static_cast<uint32_t>(frame.logical_line_offset);
        }
        line.loc.file_id = static_cast<uint16_t>(frame.logical_file_id);
        SourceLine logical_loc(line.loc);
        g_diag.add_mapping(logical_loc, physical_loc);
    }

    for (Token& tok : line.tokens) {
        SourceLine physical_loc(tok.loc);
        if (frame.logical_line_fixed) {
            tok.loc.line = static_cast<uint32_t>(frame.logical_line_offset);
        }
        else {
            tok.loc.line += static_cast<uint32_t>(frame.logical_line_offset);
        }
        tok.loc.file_id = static_cast<uint16_t>(frame.logical_file_id);
        SourceLine logical_loc(tok.loc);
        g_diag.add_mapping(logical_loc, physical_loc);
    }
}

void Preproc::process_INCLUDE(Keyword kw, const SourceLoc&,
                              const std::vector<Token>& input_line,
                              size_t& pos) {
    std::string resolved;
    SourceLoc filename_loc;
    if (!parse_and_resolve_file(input_line, pos, kw,
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
        return;     // error already emitted by get_source_file()
    }

    include_stack.push_back({
        included_file,
        included_file->file_id, // logical_file_id
        0,                  // current_line
        false,              // logical_line_fixed
        0                   // logical_line_offset
    });

    // add to dependency files for generation of .d file
    dependency_files.push_back(included_file->file_id);
}

void Preproc::process_BINARY(Keyword kw, const SourceLoc&,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    std::string resolved;
    SourceLoc filename_loc;
    if (!parse_and_resolve_file(input_line, pos, kw,
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
    std::deque<LogicalLine> binary_lines;
    for (size_t i = 0; i < data->size(); i += BYTES_PER_LINE) {
        LogicalLine line(filename_loc);
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

        line.tokens.push_back(Token::end_of_line(filename_loc));

        binary_lines.push_back(std::move(line));
    }
    push_macro_expansion(0, std::move(binary_lines));

    // generate dependency for included file
    StringInterner::Id resolved_id =
        g_file_mgr.register_virtual_file(resolved);
    dependency_files.push_back(resolved_id);
}

void Preproc::process_LINE(Keyword kw, const SourceLoc& kw_loc,
                           const std::vector<Token>& input_line,
                           size_t& pos) {
    size_t line = 0;
    std::string filename;
    if (!parse_LINE_args(input_line, pos, kw, line, filename)) {
        return; // error already emitted by parse_LINE_args()
    }

    if (include_stack.empty()) {
        g_diag.error(kw_loc,
                     keyword_to_string(kw) +
                     " directive not allowed in global scope");
        return;
    }

    IncludeFrame& frame = include_stack.back();
    frame.logical_line_fixed = false;
    frame.logical_line_offset =
        static_cast<ptrdiff_t>(line) -
        static_cast<ptrdiff_t>(frame.current_line + 1);

    if (!filename.empty()) {
        StringInterner::Id filename_id =
            g_file_mgr.register_virtual_file(filename);
        frame.logical_file_id = filename_id;
    }
}

void Preproc::process_C_LINE(Keyword kw, const SourceLoc& kw_loc,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    size_t line = 0;
    std::string filename;
    if (!parse_LINE_args(input_line, pos, kw, line, filename)) {
        return; // error already emitted by parse_LINE_args()
    }

    if (include_stack.empty()) {
        g_diag.error(kw_loc,
                     keyword_to_string(kw) +
                     " directive not allowed in global scope");
        return;
    }

    IncludeFrame& frame = include_stack.back();
    frame.logical_line_fixed = true;
    frame.logical_line_offset = static_cast<ptrdiff_t>(line);

    if (!filename.empty()) {
        StringInterner::Id filename_id =
            g_file_mgr.register_virtual_file(filename);
        frame.logical_file_id = filename_id;
    }
}

void Preproc::process_DEFINE(Keyword kw, const SourceLoc&,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " +
                     keyword_to_string(kw));
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    SourceLoc name_loc = input_line[pos].loc;
    pos++;

    // check if it's a function-like macro, i.e. if next token is '('
    // without space
    bool is_function_like = false;
    bool has_parens = false;
    std::vector<StringInterner::Id> params;
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::LeftParen &&
            input_line[pos].loc.column ==
            name_loc.column + g_strings.view(name_id).size()) {
        is_function_like = true;
        if (!parse_params(input_line, pos, params, has_parens)) {
            return; // error already emitted by parse_params()
        }
    }

    // create the macro and delegate to do_DEFINE
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params = std::move(params);
    macro.is_function_like = is_function_like;
    macro.is_multiline = false;
    macro.has_parenthesized_params =
        is_function_like && !macro.params.empty() && has_parens;
    do_DEFINE(macro, input_line, pos);
}

void Preproc::process_name_DEFINE(Keyword, const SourceLoc&,
                                  StringInterner::Id name_id, const SourceLoc& name_loc,
                                  const std::vector<Token>& input_line,
                                  size_t& pos) {
    // create the macro and delegate to do_DEFINE
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFINE(macro, input_line, pos);
}

void Preproc::do_DEFINE(const Macro& macro,
                        const std::vector<Token>& input_line, size_t& pos) {
    // check for redefinition
    auto it = macros.find(macro.name_id);
    if (it != macros.end()) {
        g_diag.error(macro.loc,
                     "Macro redefinition: " +
                     g_strings.to_string(macro.name_id));
        g_diag.note(it->second.loc, "Previous definition");
        return;
    }

    // scan optional '='
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::EQ) {
        pos++; // skip '='
    }

    // The rest of the line is the replacement list (can be empty)
    std::vector<Token> replacement;
    replacement.reserve(input_line.size() - pos);
    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine) {
        replacement.push_back(input_line[pos]);
        pos++;
    }

    // if macro is empty, add a default "1" token
    if (replacement.empty()) {
        replacement.push_back(Token::integer("1", 1, input_line.back().loc));
    }

    // if replacement is a constant expression, define a DEFC so that
    // the symbol in known at link time
    if (!macro.is_function_like) {
        // expand macros in the replacement list
        LogicalLine line{ replacement.front().loc };
        line.tokens = replacement;
        std::vector<Token> expanded;
        expand_line(line, expanded);

        // evaluate the expression and check if it's a constant expression
        // with no extra tokens
        size_t expr_pos = 0;
        int result = 0;
        if (!expanded.empty() &&
                eval_const_expr(expanded, expr_pos,
                                const_symbols, result, /*silent=*/true) &&
                expr_pos < expanded.size() &&
                expanded[expr_pos].type == TokenType::EndOfLine) {
            std::string defc_str =
                "DEFC " +
                g_strings.to_string(macro.name_id) + " = " +
                std::to_string(result);
            std::vector<Token> defc_tokens = tokenize_text(defc_str, line.loc);
            LogicalLine defc_line(line.loc);
            defc_line.tokens = std::move(defc_tokens);
            assembler_output_queue.push_back(std::move(defc_line));
        }
    }

    // create the macro and insert into the macro table
    Macro new_macro = macro;
    new_macro.tokens = std::move(replacement);
    macros[new_macro.name_id] = std::move(new_macro);
}

void Preproc::process_UNDEF(Keyword kw, const SourceLoc&,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " +
                     keyword_to_string(kw));
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    pos++;

    if (!check_end_of_line(input_line, pos, kw)) {
        return; // error already reported
    }

    do_UNDEF(name_id);
}

void Preproc::process_name_UNDEF(Keyword kw, const SourceLoc&,
                                 StringInterner::Id name_id, const SourceLoc&,
                                 const std::vector<Token>& input_line,
                                 size_t& pos) {
    if (!check_end_of_line(input_line, pos, kw)) {
        return; // error already reported
    }

    do_UNDEF(name_id);
}

void Preproc::do_UNDEF(StringInterner::Id name_id) {
    // remove from macro table
    macros.erase(name_id);
}

void Preproc::process_DEFL(Keyword kw, const SourceLoc&,
                           const std::vector<Token>& input_line,
                           size_t& pos) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " +
                     keyword_to_string(kw));
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    SourceLoc name_loc = input_line[pos].loc;
    pos++;

    // check if it's a function-like macro, i.e. if next token is '('
    // without space
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::LeftParen &&
            input_line[pos].loc.column ==
            name_loc.column + g_strings.view(name_id).size()) {
        g_diag.error(input_line[pos].loc,
                     keyword_to_string(kw) +
                     " macro cannot be function-like");
        return;
    }

    // create the macro and delegate to do_DEFL
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFL(macro, input_line, pos);
}

void Preproc::process_name_DEFL(Keyword, const SourceLoc&,
                                StringInterner::Id name_id, const SourceLoc& name_loc,
                                const std::vector<Token>& input_line,
                                size_t& pos) {
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFL(macro, input_line, pos);
}

void Preproc::do_DEFL(const Macro& macro,
                      const std::vector<Token>& input_line,
                      size_t& pos) {
    // Predefine name as an empty macro if it does not exist, so that
    // occurrences of <name> in the body expand to the previous value (if any)
    // or to empty otherwise.
    auto it = macros.find(macro.name_id);
    if (it == macros.end()) {
        Macro empty_macro = macro;
        empty_macro.tokens.clear();
        macros[macro.name_id] = std::move(empty_macro);
    }

    // make sure pre-existing macro (if any) is not function-like,
    // since DEFL cannot redefine a function-like macro
    it = macros.find(macro.name_id);
    if (it != macros.end() && it->second.is_function_like) {
        g_diag.error(macro.loc,
                     "DEFL cannot redefine function-like macro: " +
                     g_strings.to_string(macro.name_id));
        g_diag.note(it->second.loc, "Previous definition");
        return;
    }

    // scan optional '='
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::EQ) {
        pos++; // skip '='
    }

    // The rest of the line is the replacement list (can be empty)
    std::vector<Token> replacement;
    replacement.reserve(input_line.size() - pos);
    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine) {
        replacement.push_back(input_line[pos]);
        pos++;
    }

    // if macro is empty, add a default "1" token
    if (replacement.empty()) {
        replacement.push_back(Token::integer("1", 1, input_line.back().loc));
    }

    // Expand body so stored value reflects current expansions
    // (including previous value of <name> if referenced).
    LogicalLine line(replacement.front().loc);
    line.tokens = replacement;
    std::vector<Token> expanded;
    expand_line(line, expanded);

    // if replacement is a constant expression, replace it by its value
    size_t expr_pos = 0;
    int result = 0;
    if (!expanded.empty() &&
            eval_const_expr(expanded, expr_pos,
                            const_symbols, result, /*silent=*/true) &&
            expr_pos < expanded.size() &&
            expanded[expr_pos].type == TokenType::EndOfLine) {
        expanded.clear();
        expanded.push_back(Token::integer(std::to_string(result),
                                          result, line.loc));
    }

    // remove end-of-line inserted by expand_line
    if (!expanded.empty() && expanded.back().type == TokenType::EndOfLine) {
        expanded.pop_back();
    }

    // create the macro and insert into the macro table
    Macro new_macro = macro;
    new_macro.tokens = std::move(expanded);
    macros[new_macro.name_id] = std::move(new_macro);
}

void Preproc::process_MACRO(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    // parse name
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " +
                     keyword_to_string(kw));
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    SourceLoc name_loc = input_line[pos].loc;
    pos++;

    // parse optional parameters
    std::vector<StringInterner::Id> params;
    bool has_parens = false;
    if (!parse_params(input_line, pos, params, has_parens)) {
        return; // error already emitted by parse_params()
    }

    // check for end of line
    if (!check_end_of_line(input_line, pos, kw)) {
        return; // error already reported
    }

    // create the macro and delegate to do_MACRO
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params = std::move(params);
    macro.is_function_like = !macro.params.empty();
    macro.is_multiline = true;
    macro.has_parenthesized_params = has_parens;

    do_MACRO(kw, kw_loc, macro);
}

void Preproc::process_name_MACRO(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id name_id, const SourceLoc& name_loc,
                                 const std::vector<Token>& input_line,
                                 size_t& pos) {
    // parse optional parameters
    std::vector<StringInterner::Id> params;
    bool has_parens = false;
    if (!parse_params(input_line, pos, params, has_parens)) {
        return; // error already emitted by parse_params()
    }

    // check for end of line
    if (!check_end_of_line(input_line, pos, kw)) {
        return; // error already reported
    }

    // create the macro and delegate to do_MACRO
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params = std::move(params);
    macro.is_function_like = !macro.params.empty();
    macro.is_multiline = true;
    macro.has_parenthesized_params = has_parens;

    do_MACRO(kw, kw_loc, macro);
}

void Preproc::do_MACRO(Keyword kw, const SourceLoc& kw_loc,
                       const Macro& macro) {
    // check for redefinition
    auto it = macros.find(macro.name_id);
    if (it != macros.end()) {
        g_diag.error(macro.loc,
                     "Macro redefinition: " +
                     g_strings.to_string(macro.name_id));
        g_diag.note(it->second.loc, "Previous definition");
        return;
    }

    // read lines until ENDM
    std::vector<LogicalLine> lines;
    std::vector<StringInterner::Id> locals;
    if (!read_macro_body(kw, kw_loc, lines, locals)) {
        return; // error already emitted by read_macro_body()
    }

    // define the macro and insert into the macro table
    Macro new_macro = macro;
    new_macro.tokens.clear(); // not used for multiline macros
    new_macro.lines = std::move(lines);
    new_macro.locals = std::move(locals);
    macros[new_macro.name_id] = std::move(new_macro);
}

void Preproc::process_ENDM(Keyword kw, const SourceLoc& kw_loc,
                           const std::vector<Token>&, size_t&) {
    g_diag.error(kw_loc,
                 "Unexpected " + keyword_to_string(kw) + " directive");
}

void Preproc::process_REPT(Keyword kw, const SourceLoc& kw_loc,
                           const std::vector<Token>& input_line,
                           size_t& pos) {
    // Collect remaining tokens after REPT as the count expression
    std::vector<Token> expr_tokens;
    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine) {
        expr_tokens.push_back(input_line[pos]);
        pos++;
    }

    if (expr_tokens.empty()) {
        g_diag.error(kw_loc,
                     "Expected repeat count after " + keyword_to_string(kw));
        return;
    }

    // Macro-expand the expression tokens
    LogicalLine expr_line(expr_tokens.front().loc);
    expr_line.tokens = std::move(expr_tokens);
    std::vector<Token> expanded;
    expand_line(expr_line, expanded);

    // Check that expansion produced something besides EndOfLine
    if (expanded.empty() ||
            (expanded.size() == 1 &&
             expanded[0].type == TokenType::EndOfLine)) {
        g_diag.error(kw_loc,
                     "Expected repeat count after " +
                     keyword_to_string(kw));
        return;
    }

    // Evaluate constant expression (not silent -> errors are reported)
    size_t expr_pos = 0;
    int repeat_count = 0;
    if (!eval_const_expr(expanded, expr_pos,
                         const_symbols, repeat_count, /*silent=*/false)) {
        return; // error already reported by eval_const_expr
    }

    // Check no extra tokens after the expression
    if (expr_pos < expanded.size() &&
            expanded[expr_pos].type != TokenType::EndOfLine) {
        g_diag.error(expanded[expr_pos].loc,
                     "Unexpected token after " +
                     keyword_to_string(kw) +
                     " count: " +
                     g_strings.to_string(expanded[expr_pos].text_id));
        return;
    }

    // Read the body lines until ENDR
    std::vector<LogicalLine> body;
    std::vector<StringInterner::Id> locals;
    if (!read_macro_body(kw, kw_loc, body, locals)) {
        return; // error already emitted by read_macro_body()
    }

    // Push the body lines repeated repeat_count times to the work queue
    std::vector<StringInterner::Id> no_params;
    std::vector<std::vector<Token>> no_args;
    std::deque<LogicalLine> rept_lines;
    for (int i = 0; i < repeat_count; ++i) {
        for (const auto& body_line : body) {
            std::vector<Token> substituted =
                substitute_params(body_line.tokens, no_params,
                                  no_args, kw_loc, locals);

            LogicalLine ll;
            ll.tokens = std::move(substituted);
            if (ll.tokens.empty() ||
                    ll.tokens.back().type != TokenType::EndOfLine) {
                ll.tokens.push_back(Token::end_of_line(kw_loc));
            }
            ll.loc = kw_loc;

            rept_lines.push_back(std::move(ll));
        }
    }
    push_macro_expansion(0, std::move(rept_lines));
}

void Preproc::process_ENDR(Keyword kw, const SourceLoc& kw_loc,
                           const std::vector<Token>&, size_t&) {
    g_diag.error(kw_loc,
                 "Unexpected " + keyword_to_string(kw) + " directive");
}

void Preproc::process_REPTI(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    // read identifier for iteration variable
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " +
                     keyword_to_string(kw));
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    SourceLoc name_loc = input_line[pos].loc;
    pos++;

    // read comma after identifier
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Comma) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected comma after identifier in " +
                     keyword_to_string(kw));
        return;
    }
    pos++;

    do_REPTI(kw, kw_loc, name_id, name_loc, input_line, pos);
}

void Preproc::process_name_REPTI(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id name_id, const SourceLoc& name_loc,
                                 const std::vector<Token>& input_line, size_t& pos) {

    do_REPTI(kw, kw_loc, name_id, name_loc, input_line, pos);
}

void Preproc::do_REPTI(Keyword kw, const SourceLoc& kw_loc,
                       StringInterner::Id name_id, const SourceLoc&,
                       const std::vector<Token>& input_line, size_t& pos) {
    SourceLoc args_loc = pos < input_line.size() ? input_line[pos].loc : kw_loc;

    // Parse comma-separated macro arguments until EndOfLine.
    std::vector<std::vector<Token>> args;
    if (!collect_bare_args(input_line, pos, args)) {
        return; // error already emitted by collect_bare_args()
    }

    if (args.empty()) {
        g_diag.error(args_loc,
                     "Expected arguments after " + keyword_to_string(kw));
        return;
    }

    // Check end of line
    if (!check_end_of_line(input_line, pos, kw)) {
        return;
    }

    // Read the body lines until ENDR
    std::vector<LogicalLine> body;
    std::vector<StringInterner::Id> locals;
    if (!read_macro_body(kw, kw_loc, body, locals)) {
        return; // error already emitted by read_macro_body()
    }

    // The iteration variable is the single parameter for substitution
    std::vector<StringInterner::Id> params = { name_id };

    // Expand the body once per argument
    std::deque<LogicalLine> repti_lines;
    for (const auto& arg : args) {
        std::vector<std::vector<Token>> single_arg = { arg };

        for (const auto& body_line : body) {
            std::vector<Token> substituted =
                substitute_params(body_line.tokens, params,
                                  single_arg, kw_loc, locals);

            LogicalLine ll;
            ll.tokens = std::move(substituted);
            if (ll.tokens.empty() ||
                    ll.tokens.back().type != TokenType::EndOfLine) {
                ll.tokens.push_back(Token::end_of_line(kw_loc));
            }
            ll.loc = kw_loc;

            repti_lines.push_back(std::move(ll));
        }
    }
    push_macro_expansion(0, std::move(repti_lines));
}

void Preproc::process_REPTC(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    // read identifier for iteration variable
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected identifier after " + keyword_to_string(kw));
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    SourceLoc name_loc = input_line[pos].loc;
    pos++;

    // read comma after identifier
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Comma) {
        g_diag.error(pos >= input_line.size() ? input_line.back().loc :
                     input_line[pos].loc,
                     "Expected comma after identifier in " + keyword_to_string(kw));
        return;
    }
    pos++;

    do_REPTC(kw, kw_loc, name_id, name_loc, input_line, pos);
}

void Preproc::process_name_REPTC(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id name_id, const SourceLoc& name_loc,
                                 const std::vector<Token>& input_line,
                                 size_t& pos) {
    do_REPTC(kw, kw_loc, name_id, name_loc, input_line, pos);
}

void Preproc::do_REPTC(Keyword kw, const SourceLoc& kw_loc,
                       StringInterner::Id name_id, const SourceLoc&,
                       const std::vector<Token>& input_line,
                       size_t& pos) {
    SourceLoc args_loc = pos < input_line.size() ? input_line[pos].loc : kw_loc;

    // Collect all tokens until EndOfLine
    std::vector<Token> raw_tokens;
    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine) {
        raw_tokens.push_back(input_line[pos]);
        pos++;
    }

    if (raw_tokens.empty()) {
        g_diag.error(args_loc,
                     "Expected text after " + keyword_to_string(kw));
        return;
    }

    // Macro-expand the collected tokens
    LogicalLine expr_line(raw_tokens.front().loc);
    expr_line.tokens = std::move(raw_tokens);
    std::vector<Token> expanded;
    expand_line(expr_line, expanded);

    // Read the body lines until ENDR
    std::vector<LogicalLine> body;
    std::vector<StringInterner::Id> locals;
    if (!read_macro_body(kw, kw_loc, body, locals)) {
        return; // error already emitted by read_macro_body()
    }

    // Build the character string by concatenating the text representation
    // of each expanded token
    std::string chars;
    for (const auto& tok : expanded) {
        if (tok.type == TokenType::EndOfLine) {
            continue;
        }
        switch (tok.type) {
        case TokenType::String:
            chars += g_strings.view(tok.value.str_value_id);
            break;
        case TokenType::Integer:
            chars += std::to_string(tok.value.int_value);
            break;
        default:
            chars += g_strings.view(tok.text_id);
            break;
        }
    }

    if (chars.empty()) {
        return; // nothing to iterate
    }

    // The iteration variable is the single parameter for substitution
    std::vector<StringInterner::Id> params = { name_id };

    // Iterate over each character
    std::deque<LogicalLine> reptc_lines;
    for (char ch : chars) {
        int char_val = static_cast<unsigned char>(ch);
        Token char_token = Token::integer(std::to_string(char_val),
                                          char_val, kw_loc);
        std::vector<std::vector<Token>> single_arg = { { char_token } };

        for (const auto& body_line : body) {
            std::vector<Token> substituted =
                substitute_params(body_line.tokens, params,
                                  single_arg, kw_loc, locals);

            LogicalLine ll;
            ll.tokens = std::move(substituted);
            if (ll.tokens.empty() ||
                    ll.tokens.back().type != TokenType::EndOfLine) {
                ll.tokens.push_back(Token::end_of_line(kw_loc));
            }
            ll.loc = kw_loc;

            reptc_lines.push_back(std::move(ll));
        }
    }
    push_macro_expansion(0, std::move(reptc_lines));
}

void Preproc::process_LOCAL(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>&, size_t&) {
    g_diag.error(kw_loc,
                 "Unexpected " + keyword_to_string(kw) + " directive");
}

void Preproc::process_name_LOCAL(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id, const SourceLoc&,
                                 const std::vector<Token>&,
                                 size_t&) {
    g_diag.error(kw_loc,
                 "Unexpected " + keyword_to_string(kw) + " directive");
}

void Preproc::process_EXITM(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    if (!check_end_of_line(input_line, pos, kw)) {
        return;
    }

    // Search the expansion stack top-down for the first frame
    // created by a macro invocation (name_id != 0)
    for (auto it = macro_expansion_stack.rbegin();
            it != macro_expansion_stack.rend(); ++it) {
        if (it->name_id != 0) {
            it->exited = true;
            return;
        }
    }

    g_diag.error(kw_loc,
                 keyword_to_string(kw) + " outside of macro expansion");
}

void Preproc::process_IF(Keyword kw, const SourceLoc& kw_loc,
                         const std::vector<Token>& input_line,
                         size_t& pos) {
    bool cond_value = eval_if_expr(input_line, pos, kw);

    ConditionalFrame frame;
    frame.if_loc = kw_loc;
    frame.branch_active = cond_value;
    frame.any_taken = cond_value;
    frame.seen_else = false;
    cond_stack.push_back(std::move(frame));
}

void Preproc::process_ELSEIF(Keyword kw, const SourceLoc& kw_loc,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + keyword_to_string(kw) +
                     " directive without matching IF");
        return;
    }

    ConditionalFrame& frame = cond_stack.back();
    if (frame.seen_else) {
        g_diag.error(kw_loc,
                     "Unexpected " + keyword_to_string(kw) +
                     " directive after ELSE");
        return;
    }

    bool cond_value = eval_if_expr(input_line, pos, kw);
    bool active_now = (!frame.any_taken) && cond_value;
    frame.branch_active = active_now;
    if (active_now) {
        frame.any_taken = true;
    }
}

void Preproc::process_ELSE(Keyword kw, const SourceLoc& kw_loc,
                           const std::vector<Token>& input_line,
                           size_t& pos) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + keyword_to_string(kw) +
                     " directive without matching IF");
        return;
    }

    ConditionalFrame& frame = cond_stack.back();
    if (!check_end_of_line(input_line, pos, kw)) {
        return;
    }

    if (frame.seen_else) {
        g_diag.error(kw_loc, "Multiple " + keyword_to_string(kw) + " in IF block");
    }

    frame.branch_active = !frame.any_taken;
    frame.any_taken = true;
    frame.seen_else = true;
}

void Preproc::process_ENDIF(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>& input_line, size_t& pos) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + keyword_to_string(kw) +
                     " directive without matching IF");
        return;
    }

    if (!check_end_of_line(input_line, pos, kw)) {
        return;
    }

    cond_stack.pop_back();
}

void Preproc::process_IFDEF(Keyword kw, const SourceLoc& kw_loc,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    do_IFDEF_IFNDEF(false, kw, kw_loc, input_line, pos);
}

void Preproc::process_IFNDEF(Keyword kw, const SourceLoc& kw_loc,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    do_IFDEF_IFNDEF(true, kw, kw_loc, input_line, pos);
}

void Preproc::do_IFDEF_IFNDEF(bool negated,
                              Keyword kw, const SourceLoc& kw_loc,
                              const std::vector<Token>& input_line, size_t& pos) {
    bool cond = eval_ifdef_name(input_line, pos, negated, kw);

    ConditionalFrame frame;
    frame.if_loc = kw_loc;
    frame.branch_active = cond;
    frame.any_taken = cond;
    frame.seen_else = false;
    cond_stack.push_back(std::move(frame));
}

void Preproc::process_ELSEIFDEF(Keyword kw, const SourceLoc& kw_loc,
                                const std::vector<Token>& input_line,
                                size_t& pos) {
    do_ELSEIFDEF_ELSEIFNDEF(false, kw, kw_loc, input_line, pos);
}

void Preproc::process_ELSEIFNDEF(Keyword kw, const SourceLoc& kw_loc,
                                 const std::vector<Token>& input_line,
                                 size_t& pos) {
    do_ELSEIFDEF_ELSEIFNDEF(true, kw, kw_loc, input_line, pos);
}

void Preproc::do_ELSEIFDEF_ELSEIFNDEF(bool negated,
                                      Keyword kw, const SourceLoc& kw_loc,
                                      const std::vector<Token>& input_line, size_t& pos) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + keyword_to_string(kw) +
                     " directive without matching IF");
        return;
    }

    ConditionalFrame& frame = cond_stack.back();
    if (frame.seen_else) {
        g_diag.error(kw_loc,
                     "Unexpected " + keyword_to_string(kw) +
                     " directive after ELSE");
        return;
    }

    bool cond = eval_ifdef_name(input_line, pos, negated, kw);
    bool active_now = (!frame.any_taken) && cond;
    frame.branch_active = active_now;
    if (active_now) {
        frame.any_taken = true;
    }
}

void Preproc::process_PRAGMA(Keyword kw, const SourceLoc&,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    // Reserve PRAGMA for future extensions:
    // only handle "PRAGMA ONCE", ignore anything else.
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier ||
            input_line[pos].keyword != Keyword::ONCE) {
        return;
    }

    // consume ONCE
    pos++;

    // PRAGMA ONCE must have no extra tokens
    if (!check_end_of_line(input_line, pos, kw)) {
        return;
    }

    // PRAGMA ONCE in current file
    if (include_stack.empty() || include_stack.back().file == nullptr) {
        return;
    }

    StringInterner::Id file_id = include_stack.back().file->file_id;
    auto it = std::find(pragma_once_files.begin(), pragma_once_files.end(), file_id);

    if (it != pragma_once_files.end()) {
        // file already marked once -> skip remaining lines of this file
        include_stack.pop_back();
    }
    else {
        // first time this file requests PRAGMA ONCE
        pragma_once_files.push_back(file_id);
    }
}

void Preproc::process_ASSERT(Keyword kw, const SourceLoc& kw_loc,
                             const std::vector<Token>& input_line,
                             size_t& pos) {
    // Collect everything after ASSERT until EndOfLine
    std::vector<Token> raw_tokens;
    while (pos < input_line.size() &&
            input_line[pos].type != TokenType::EndOfLine) {
        raw_tokens.push_back(input_line[pos]);
        pos++;
    }

    if (raw_tokens.empty()) {
        g_diag.error(kw_loc, "Expected expression after " +
                     keyword_to_string(kw));
        return;
    }

    // Expand macros in ASSERT arguments
    LogicalLine expr_line(raw_tokens.front().loc);
    expr_line.tokens = std::move(raw_tokens);
    std::vector<Token> expanded;
    expand_line(expr_line, expanded);

    if (expanded.empty() ||
            (expanded.size() == 1 &&
             expanded[0].type == TokenType::EndOfLine)) {
        g_diag.error(kw_loc, "Expected expression after " +
                     keyword_to_string(kw));
        return;
    }

    // Evaluate constant expression
    const SourceLoc expr_loc = expanded.front().loc;
    size_t expr_pos = 0;
    int result = 0;
    if (!eval_const_expr(expanded, expr_pos,
                         const_symbols, result, /*silent=*/false)) {
        // syntax/non-constant errors already reported
        return;
    }

    // Optional: , "message"
    std::string message;
    if (expr_pos < expanded.size() &&
            expanded[expr_pos].type == TokenType::Comma) {
        ++expr_pos;

        if (expr_pos >= expanded.size() ||
                expanded[expr_pos].type != TokenType::String) {
            g_diag.error(expr_pos >= expanded.size() ? expanded.back().loc :
                         expanded[expr_pos].loc,
                         "Expected string after comma in " +
                         keyword_to_string(kw));
            return;
        }

        message = g_strings.to_string(expanded[expr_pos].value.str_value_id);
        ++expr_pos;
    }

    // Must end at EOL
    if (!check_end_of_line(expanded, expr_pos, kw)) {
        return;
    }

    // Assertion passed
    if (result != 0) {
        return;
    }

    // Assertion failed
    g_diag.error(expr_loc, message.empty() ? "Assertion failed" : message);
}

void Preproc::process_ERROR(Keyword kw, const SourceLoc&,
                            const std::vector<Token>& input_line,
                            size_t& pos) {
    // Optional: ERROR "message"
    std::string message = "User specified error";
    SourceLoc err_loc = (pos < input_line.size()) ? input_line[pos].loc
                        : (input_line.empty() ? SourceLoc{} : input_line.back().loc);

    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::String) {
        message = g_strings.to_string(input_line[pos].value.str_value_id);
        err_loc = input_line[pos].loc;
        ++pos;
    }

    // Must end at EOL (or only have EOL tokens left)
    if (!check_end_of_line(input_line, pos, kw)) {
        return;
    }

    g_diag.error(err_loc, message);
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

    const Token& first_tok = input_line[pos];

    // ---------------------------------------------------------------------
    // 2. If inside inactive conditional block or exited macro,
    //    only IF/ELSEIF/ELSE/ENDIF run
    // ---------------------------------------------------------------------
    bool cond_active = is_cond_active() && !is_macro_exited();

    // ---------------------------------------------------------------------
    // 3. Check if first token is a directive keyword (possibly after #)
    // ---------------------------------------------------------------------
    Keyword kw = Keyword::None;
    SourceLoc kw_loc;
    StringInterner::Id name_id = 0;
    SourceLoc name_loc;

    if (!is_directive(input_line, pos, kw, kw_loc, name_id, name_loc)) {
        // Not a directive
        if (!cond_active) {
            return LineType::Skip;
        }

        out_line.tokens = input_line;
        rewrite_logical_line(out_line);
        return LineType::Normal;
    }

    // ---------------------------------------------------------------------
    // 4. Dispatch to directive handlers
    // ---------------------------------------------------------------------

    // ---------------------------------------------------------------------
    // If conditional block inactive, ignore all other directives
    // ---------------------------------------------------------------------
    if (!keyword_is_conditional_directive(kw) && !cond_active) {
        return LineType::Skip;
    }

    // ---------------------------------------------------------------------
    // Non-conditional directives
    // ---------------------------------------------------------------------
    if (name_id == 0) {
        // Handle normal directives starting with directive keyword
        auto it = directive_handlers_.find(kw);
        if (it != directive_handlers_.end()) {
            (this->*it->second)(kw, kw_loc, input_line, pos);
            return LineType::ControlOnly;
        }
    }
    else {
        // Handle "name DEFINE 1" style directives with name
        // before directive keyword
        auto it = name_directive_handlers_.find(kw);
        if (it != name_directive_handlers_.end()) {
            (this->*it->second)(kw, kw_loc, name_id, name_loc, input_line, pos);
            return LineType::ControlOnly;
        }
    }

    // ---------------------------------------------------------------------
    // Unknown directive -> error
    // ---------------------------------------------------------------------
    g_diag.error(first_tok.loc, "Unknown preprocessor directive: " +
                 keyword_to_string(kw));
    return LineType::ControlOnly;
}
