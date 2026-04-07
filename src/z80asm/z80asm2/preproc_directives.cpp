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
#include <unordered_map>
#include <vector>

static const size_t BYTES_PER_LINE = 16;

//-----------------------------------------------------------------------------
// dispatch table for directives
//-----------------------------------------------------------------------------

std::unordered_map<Keyword, Preproc::DirectiveHandler>
Preproc::directive_handlers_ = {
    { Keyword::INCLUDE, &Preproc::process_INCLUDE },
    { Keyword::BINARY,  &Preproc::process_BINARY },
    { Keyword::INCBIN,  &Preproc::process_BINARY },
    { Keyword::LINE,    &Preproc::process_LINE },
    { Keyword::C_LINE,  &Preproc::process_C_LINE },
    { Keyword::DEFINE,  &Preproc::process_DEFINE },
    { Keyword::UNDEF,   &Preproc::process_UNDEF },
    { Keyword::UNDEFINE, &Preproc::process_UNDEF },
    { Keyword::DEFL,    &Preproc::process_DEFL },
};

std::unordered_map<Keyword, Preproc::NameDirectiveHandler>
Preproc::name_directive_handlers_ = {
    { Keyword::DEFINE,  &Preproc::process_name_DEFINE },
    { Keyword::UNDEF,   &Preproc::process_name_UNDEF },
    { Keyword::UNDEFINE, &Preproc::process_name_UNDEF },
    { Keyword::DEFL,    &Preproc::process_name_DEFL },
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
    if (pos >= input_line.size() ||
            input_line[pos].type == TokenType::EndOfLine) {
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

bool Preproc::parse_LINE_args(const std::vector<Token>& input_line,
                              size_t& pos,
                              std::string_view directive_name,
                              size_t& out_linenum,
                              std::string& out_filename) {
    out_linenum = 0;
    out_filename.clear();

    // accept line number
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Integer) {
        g_diag.error(input_line[pos].loc, "Expected line number after " +
                     std::string(directive_name));
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
        if (!parse_filename(input_line, pos, directive_name,
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

bool Preproc::parse_parameters(const std::vector<Token>& input_line,
                               size_t& pos,
                               std::vector<StringInterner::Id>& out_params) {
    out_params.clear();
    bool has_parens = false;

    // Helper: report failure with a message and clear out_params
    auto fail = [&](std::string_view message) {
        g_diag.error(input_line[pos].loc, message);
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
        has_parens = true;
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
    if (!has_parens) {
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
    if (has_parens) {
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
        included_file->file_id, // logical_file_id
        0,                  // current_line
        false,              // logical_line_fixed
        0                   // logical_line_offset
    });

    // add to dependency files for generation of .d file
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

void Preproc::process_LINE(const std::vector<Token>& input_line, size_t& pos) {
    size_t line = 0;
    std::string filename;
    if (!parse_LINE_args(input_line, pos, "LINE", line, filename)) {
        return; // error already emitted by parse_LINE_args()
    }

    if (include_stack.empty()) {
        g_diag.error(input_line[pos].loc,
                     "LINE directive not allowed in global scope");
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

void Preproc::process_C_LINE(const std::vector<Token>& input_line, size_t& pos) {
    size_t line = 0;
    std::string filename;
    if (!parse_LINE_args(input_line, pos, "C_LINE", line, filename)) {
        return; // error already emitted by parse_LINE_args()
    }

    if (include_stack.empty()) {
        g_diag.error(input_line[pos].loc,
                     "C_LINE directive not allowed in global scope");
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

void Preproc::process_DEFINE(const std::vector<Token>& input_line, size_t& pos) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(input_line[pos].loc, "Expected macro name after DEFINE");
        return;
    }
    StringInterner::Id name_id = input_line[pos].text_id;
    SourceLoc name_loc = input_line[pos].loc;
    pos++;

    // check if it's a function-like macro, i.e. if next token is '('
    // without space
    bool is_function_like = false;
    std::vector<StringInterner::Id> params;
    if (pos < input_line.size() &&
            input_line[pos].type == TokenType::LeftParen &&
            input_line[pos].loc.column ==
            name_loc.column + g_strings.view(name_id).size()) {
        is_function_like = true;
        if (!parse_parameters(input_line, pos, params)) {
            return; // error already emitted by parse_parameters()
        }
    }

    // create the macro and delegate to do_DEFINE
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params = std::move(params);
    macro.is_function_like = is_function_like;
    macro.is_multiline = false;

    do_DEFINE(macro, input_line, pos);
}

void Preproc::process_name_DEFINE(std::string_view name,
                                  const SourceLoc& name_loc,
                                  const std::vector<Token>& input_line,
                                  size_t& pos) {
    StringInterner::Id name_id = g_strings.intern(name);

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
        LogicalLine line{ replacement, replacement.front().loc };
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
            LogicalLine defc_line{ {}, line.loc };
            defc_line.tokens = std::move(defc_tokens);
            assembler_output_queue.push_back(std::move(defc_line));
        }
    }

    // create the macro and insert into the macro table
    Macro new_macro = macro;
    new_macro.tokens = std::move(replacement);
    macros[new_macro.name_id] = std::move(new_macro);
}

void Preproc::process_UNDEF(const std::vector<Token>& input_line, size_t& pos) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(input_line[pos].loc, "Expected macro name after UNDEF");
        return;
    }

    StringInterner::Id name_id = input_line[pos].text_id;
    pos++;

    check_end_of_line(input_line, pos, "UNDEF");
    do_UNDEF(name_id);
}

void Preproc::process_name_UNDEF(std::string_view name,
                                 const SourceLoc&,
                                 const std::vector<Token>& input_line,
                                 size_t& pos) {
    StringInterner::Id name_id = g_strings.intern(name);

    check_end_of_line(input_line, pos, "UNDEF");
    do_UNDEF(name_id);
}

void Preproc::do_UNDEF(StringInterner::Id name_id) {
    // remove from macro table
    macros.erase(name_id);
}

void Preproc::process_DEFL(const std::vector<Token>& input_line, size_t& pos) {
    if (pos >= input_line.size() ||
            input_line[pos].type != TokenType::Identifier) {
        g_diag.error(input_line[pos].loc, "Expected macro name after DEFL");
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
        g_diag.error(input_line[pos].loc, "DEFL macro cannot be function-like");
        return;
    }

    // create the macro and delegate to do_DEFINE
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFL(macro, input_line, pos);
}

void Preproc::process_name_DEFL(std::string_view name,
                                const SourceLoc& name_loc,
                                const std::vector<Token>& input_line, size_t& pos) {
    StringInterner::Id name_id = g_strings.intern(name);

    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFL(macro, input_line, pos);
}

void Preproc::do_DEFL(const Macro& macro,
                      const std::vector<Token>& input_line, size_t& pos) {
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
    LogicalLine line{ replacement, replacement.front().loc };
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

    // Support cpp style line markers:
    // "# <nr>" or "# <nr> , <filename>" or "# <nr> <filename>"
    // Treat them as synonyms of "#line <nr> [ , filename ]"
    if (first.type == TokenType::Hash && pos < input_line.size() &&
            input_line[pos].type == TokenType::Integer) {
        kw = Keyword::LINE;
    }

    // support cpp style directives with #, e.g. "# define X 1"
    if (first.type == TokenType::Hash && pos < input_line.size() &&
            input_line[pos].type == TokenType::Identifier) {
        kw = input_line[pos].keyword;
        ++pos;
    }

    // support "name DEFINE 1" as synonym of "#define name 1"
    bool has_name = false;
    std::string name;
    SourceLoc name_loc;
    if (first.type == TokenType::Identifier && pos < input_line.size() &&
            input_line[pos].type == TokenType::Identifier &&
            keyword_is_preproc_name_directive(input_line[pos].keyword)) {
        has_name = true;
        name = g_strings.view(first.text_id);
        name_loc = first.loc;
        kw = input_line[pos].keyword;
        pos++; // consume the directive keyword
    }

    if (!keyword_is_preproc_directive(kw) &&
            !keyword_is_preproc_name_directive(kw)) {
        // Not a directive keyword
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
    if (has_name) {
        // Handle "name DEFINE 1" style directives with name
        // before directive keyword
        auto it = name_directive_handlers_.find(kw);
        if (it != name_directive_handlers_.end()) {
            (this->*it->second)(name, name_loc, input_line, pos);
            return LineType::ControlOnly;
        }
    }
    else {
        // Handle normal directives starting with directive keyword
        auto it = directive_handlers_.find(kw);
        if (it != directive_handlers_.end()) {
            (this->*it->second)(input_line, pos);
            return LineType::ControlOnly;
        }
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
    // Unknown directive -> error
    // ---------------------------------------------------------------------
    g_diag.error(first.loc, "Unknown preprocessor directive: " +
                 keyword_to_string(kw));
    return LineType::ControlOnly;
}
