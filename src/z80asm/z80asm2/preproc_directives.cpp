//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "const_symbols.h"
#include "cpu.h"
#include "diag.h"
#include "expr.h"
#include "file_mgr.h"
#include "lexer.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "options.h"
#include "pathnames.h"
#include "preproc.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <algorithm>
#include <cassert>
#include <deque>
#include <unordered_map>
#include <utility>
#include <vector>

static const size_t BYTES_PER_LINE = 16;

//-----------------------------------------------------------------------------
// dispatch table for directives
//-----------------------------------------------------------------------------

std::unordered_map<Keyword, Preproc::DirectiveHandler>
Preproc::directive_handlers = {
    { Keyword::ASSERT,     &Preproc::process_ASSERT },
    { Keyword::ASSUME,     &Preproc::process_ASSUME },
    { Keyword::BINARY,     &Preproc::process_BINARY },
    { Keyword::C_LINE,     &Preproc::process_C_LINE },
    { Keyword::CALL_OZ,    &Preproc::process_Z88_CALL_OZ },
    { Keyword::CALL_PKG,   &Preproc::process_Z88_CALL_PKG },
    { Keyword::CU_MOVE,    &Preproc::process_CU_MOVE },
    { Keyword::CU_NOP,     &Preproc::process_CU_NOP },
    { Keyword::CU_STOP,    &Preproc::process_CU_STOP },
    { Keyword::CU_WAIT,    &Preproc::process_CU_WAIT },
    { Keyword::DEFGROUP,   &Preproc::process_DEFGROUP },
    { Keyword::DEFINE,     &Preproc::process_DEFINE },
    { Keyword::DEFL,       &Preproc::process_DEFL },
    { Keyword::DEFVARS,    &Preproc::process_DEFVARS },
    { Keyword::ENDM,       &Preproc::process_ENDM },
    { Keyword::ENDR,       &Preproc::process_ENDR },
    { Keyword::ERROR,      &Preproc::process_ERROR },
    { Keyword::EXITM,      &Preproc::process_EXITM },
    { Keyword::INCBIN,     &Preproc::process_BINARY },
    { Keyword::INCLUDE,    &Preproc::process_INCLUDE },
    { Keyword::LINE,       &Preproc::process_LINE },
    { Keyword::LOCAL,      &Preproc::process_LOCAL },
    { Keyword::MACRO,      &Preproc::process_MACRO },
    { Keyword::PRAGMA,     &Preproc::process_PRAGMA },
    { Keyword::REPT,       &Preproc::process_REPT },
    { Keyword::REPTC,      &Preproc::process_REPTC },
    { Keyword::REPTI,      &Preproc::process_REPTI },
    { Keyword::UNDEF,      &Preproc::process_UNDEF },
    { Keyword::UNDEFINE,   &Preproc::process_UNDEF },
    { Keyword::DMA_WR0,    &Preproc::process_DMA },
    { Keyword::DMA_WR1,    &Preproc::process_DMA },
    { Keyword::DMA_WR2,    &Preproc::process_DMA },
    { Keyword::DMA_WR3,    &Preproc::process_DMA },
    { Keyword::DMA_WR4,    &Preproc::process_DMA },
    { Keyword::DMA_WR5,    &Preproc::process_DMA },
    { Keyword::DMA_WR6,    &Preproc::process_DMA },
    { Keyword::DMA_CMD,    &Preproc::process_DMA },
};

std::unordered_map<Keyword, Preproc::DirectiveHandler>
Preproc::conditional_handlers = {
    { Keyword::ELIF,       &Preproc::process_ELSEIF },
    { Keyword::ELIFDEF,    &Preproc::process_ELSEIFDEF },
    { Keyword::ELIFNDEF,   &Preproc::process_ELSEIFNDEF },
    { Keyword::ELSE,       &Preproc::process_ELSE },
    { Keyword::ELSEIF,     &Preproc::process_ELSEIF },
    { Keyword::ELSEIFDEF,  &Preproc::process_ELSEIFDEF },
    { Keyword::ELSEIFNDEF, &Preproc::process_ELSEIFNDEF },
    { Keyword::ENDIF,      &Preproc::process_ENDIF },
    { Keyword::IF,         &Preproc::process_IF },
    { Keyword::IFDEF,      &Preproc::process_IFDEF },
    { Keyword::IFNDEF,     &Preproc::process_IFNDEF },
};

std::unordered_map<Keyword, Preproc::NameDirectiveHandler>
Preproc::name_directive_handlers = {
    { Keyword::DEFC,     &Preproc::process_name_DEFC },
    { Keyword::DEFINE,   &Preproc::process_name_DEFINE },
    { Keyword::DEFL,     &Preproc::process_name_DEFL },
    { Keyword::EQU,      &Preproc::process_name_DEFC },
    { Keyword::LOCAL,    &Preproc::process_name_LOCAL },
    { Keyword::MACRO,    &Preproc::process_name_MACRO },
    { Keyword::REPTC,    &Preproc::process_name_REPTC },
    { Keyword::REPTI,    &Preproc::process_name_REPTI },
    { Keyword::UNDEF,    &Preproc::process_name_UNDEF },
    { Keyword::UNDEFINE, &Preproc::process_name_UNDEF },
};

//-----------------------------------------------------------------------------
// directive handlers and helpers
//-----------------------------------------------------------------------------

bool Preproc::is_directive_keyword(Keyword kw) {
    return directive_handlers.find(kw) != directive_handlers.end() ||
           conditional_handlers.find(kw) != conditional_handlers.end();
}

bool Preproc::is_conditional_directive_keyword(Keyword kw) {
    return conditional_handlers.find(kw) != conditional_handlers.end();
}

bool Preproc::is_name_directive_keyword(Keyword kw) {
    return name_directive_handlers.find(kw) != name_directive_handlers.end();
}

bool Preproc::is_directive(ParseLine& pline,
                           Keyword& out_kw,
                           SourceLoc& out_kw_loc,
                           StringInterner::Id& out_name_id,
                           SourceLoc& out_name_loc) {
    out_kw = Keyword::None;
    out_kw_loc.clear();
    out_name_id = 0;
    out_name_loc.clear();

    // DIRECTIVE
    if (pline.peek().type == TokenType::Identifier &&
            is_directive_keyword(pline.peek().keyword)) {
        out_kw = pline.peek().keyword;
        out_kw_loc = pline.peek().loc;
        pline.advance(); // consume directive keyword
        return true;
    }

    // # DIRECTIVE
    if (pline.peek().type == TokenType::Hash &&
            pline.peek(1).type == TokenType::Identifier &&
            is_directive_keyword(pline.peek(1).keyword)) {
        out_kw = pline.peek(1).keyword;
        out_kw_loc = pline.peek(1).loc;
        pline.pos += 2; // consume '#' and directive keyword
        return true;
    }

    // # LINE_NUMBER
    if (pline.peek().type == TokenType::Hash &&
            pline.peek(1).type == TokenType::Integer) {
        out_kw = Keyword::LINE;
        out_kw_loc = pline.peek().loc;
        pline.advance(); // consume '#'
        return true;
    }

    // name DIRECTIVE
    if (pline.peek().type == TokenType::Identifier &&
            pline.peek(1).type == TokenType::Identifier &&
            is_name_directive_keyword(pline.peek(1).keyword)) {
        out_kw = pline.peek(1).keyword;
        out_kw_loc = pline.peek(1).loc;
        out_name_id = pline.peek().text_id;
        out_name_loc = pline.peek().loc;
        pline.pos += 2; // consume name and directive keyword
        return true;
    }

    // .ASSUME ADL=0/1
    if (pline.peek().type == TokenType::Dot &&
            pline.peek(1).keyword == Keyword::ASSUME) {
        out_kw = Keyword::ASSUME;
        out_kw_loc = pline.peek(1).loc;
        pline.pos += 2; // consume '.' and 'ASSUME'
        return true;
    }

    // Spectrum Next copper unit directive
    if (pline.peek().keyword == Keyword::CU &&
            pline.peek(1).type == TokenType::Dot) {
        switch (pline.peek(2).keyword) {
        case Keyword::WAIT:
            out_kw = Keyword::CU_WAIT;
            break;
        case Keyword::MOVE:
            out_kw = Keyword::CU_MOVE;
            break;
        case Keyword::STOP:
            out_kw = Keyword::CU_STOP;
            break;
        case Keyword::NOP:
            out_kw = Keyword::CU_NOP;
            break;
        default:
            goto not_copper;
        }

        out_kw_loc = pline.peek().loc;
        pline.pos += 3; // consume 'CU', '.' and <directive>
        return true;
    }
not_copper:

    // Spectrum Next DMA unit directive
    if (pline.peek().keyword == Keyword::DMA &&
            pline.peek(1).type == TokenType::Dot) {
        switch (pline.peek(2).keyword) {
        case Keyword::WR0:
            out_kw = Keyword::DMA_WR0;
            break;
        case Keyword::WR1:
            out_kw = Keyword::DMA_WR1;
            break;
        case Keyword::WR2:
            out_kw = Keyword::DMA_WR2;
            break;
        case Keyword::WR3:
            out_kw = Keyword::DMA_WR3;
            break;
        case Keyword::WR4:
            out_kw = Keyword::DMA_WR4;
            break;
        case Keyword::WR5:
            out_kw = Keyword::DMA_WR5;
            break;
        case Keyword::WR6:
            out_kw = Keyword::DMA_WR6;
            break;
        case Keyword::CMD:
            out_kw = Keyword::DMA_CMD;
            break;
        default:
            goto not_dma;
        }

        out_kw_loc = pline.peek().loc;
        pline.pos += 3; // consume 'DMA', '.' and <directive>
        return true;
    }
not_dma:

    return false;
}

bool Preproc::parse_filename(ParseLine& pline,
                             Keyword kw,
                             std::string& out_filename,
                             bool& out_is_angle_bracket,
                             SourceLoc& out_filename_loc) {
    if (pline.peek().type == TokenType::EndOfLine) {
        pline.error("Expected filename after " +
                    to_string(kw));
        return false;
    }

    // accept "file" or <file>
    if (pline.peek().type == TokenType::String) {
        out_filename =
            g_strings.view(pline.peek().value.str_value_id);
        std::string_view quoted_filename =
            g_strings.view(pline.peek().text_id);
        out_is_angle_bracket = !quoted_filename.empty() &&
                               quoted_filename.front() == '<' && quoted_filename.back() == '>';
        out_filename_loc = pline.peek().loc;
        pline.advance();
        return true;
    }

    // accept sequence of tokens until a space
    std::string_view token_text = g_strings.view(pline.peek().text_id);
    if (token_text.size() == 0 || is_space(token_text.front())) {
        pline.error("Expected filename after " +
                    to_string(kw));
        return false;
    }

    out_is_angle_bracket = false;
    out_filename = token_text;
    out_filename_loc = pline.peek().loc;
    size_t column = pline.peek().loc.column + token_text.size();
    pline.advance();

    while (pline.peek().type != TokenType::EndOfLine &&
            pline.peek().loc.column == column) {
        token_text = g_strings.view(pline.peek().text_id);
        out_filename += token_text;
        column = pline.peek().loc.column + token_text.size();
        pline.advance();
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
bool Preproc::parse_and_resolve_file(ParseLine& pline,
                                     Keyword kw,
                                     std::string& out_resolved,
                                     SourceLoc& out_filename_loc) {
    std::string filename;
    bool is_angle_bracket = false;
    if (!parse_filename(pline, kw,
                        filename, is_angle_bracket, out_filename_loc)) {
        return false;
    }

    if (!pline.check_end_of_line()) {
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

bool Preproc::parse_LINE_args(ParseLine& pline,
                              Keyword kw,
                              size_t& out_linenum,
                              std::string& out_filename) {
    out_linenum = 0;
    out_filename.clear();

    // accept line number
    if (pline.peek().type != TokenType::Integer) {
        pline.error("Expected line number after " +
                    to_string(kw));
        return false;
    }

    out_linenum = static_cast<size_t>(pline.peek().value.int_value);
    pline.advance();

    // skip optional comma
    if (pline.peek().type == TokenType::Comma) {
        pline.advance();
    }

    if (pline.peek().type == TokenType::EndOfLine) {
        return true;    // no filename, but that's fine
    }

    // accept optional filename
    std::string_view token_text = g_strings.view(pline.peek().text_id);
    if (!token_text.empty() && !is_space(token_text.front())) {
        bool is_angle_bracket = false;
        SourceLoc filename_loc;
        if (!parse_filename(pline, kw,
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

bool Preproc::parse_params(ParseLine& pline,
                           std::vector<StringInterner::Id>& out_params,
                           bool& out_has_parens) {
    out_params.clear();
    out_has_parens = false;

    // Helper: report failure with a message and clear out_params
    auto fail = [&](std::string_view message) {
        pline.error(message);
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
    if (pline.peek().type == TokenType::LeftParen) {
        out_has_parens = true;
        pline.advance(); // consume '('

        // Empty list "()"
        if (pline.peek().type == TokenType::RightParen) {
            pline.advance();
            return true;
        }

        // If right after '(' we don't have an identifier, it's a syntax error
        if (pline.peek().type != TokenType::Identifier) {
            return fail("Identifier expected");
        }
    }

    // If not in parens and next token is not an identifier, treat as empty list
    if (!out_has_parens) {
        if (pline.peek().type != TokenType::Identifier) {
            // Empty parameter list without parentheses;
            // success with index unchanged
            return true;
        }
    }

    // Parse first identifier
    if (pline.peek().type == TokenType::Identifier) {
        if (!add_param(pline.peek().text_id)) {
            return false;
        }
        pline.advance();
    }
    else {
        // Guard: should not happen due to checks above
        return fail("Identifier expected");
    }

    // Parse subsequent ", identifier" pairs
    while (pline.peek().type == TokenType::Comma) {
        pline.advance(); // skip comma
        if (pline.peek().type == TokenType::Identifier) {
            if (!add_param(pline.peek().text_id)) {
                return false;
            }
            pline.advance();
        }
        else {
            return fail("Identifier expected");
        }
    }

    // If we started with '(', we must end with ')'
    if (out_has_parens) {
        if (pline.peek().type == TokenType::RightParen) {
            pline.advance();
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
        ParseLine pl(line.tokens);

        if (is_directive(pl, kw, kw_loc, name_id, name_loc)) {
            // Opening keywords: push onto nesting stack
            if (kw == Keyword::MACRO ||
                    kw == Keyword::REPT ||
                    kw == Keyword::REPTC ||
                    kw == Keyword::REPTI) {
                nesting_stack.push_back({ kw, kw_loc });
            }
            // Closing keywords: validate and pop
            else if (kw == Keyword::ENDM || kw == Keyword::ENDR) {
                if (!pl.check_end_of_line()) {
                    return false;
                }

                if (nesting_stack.empty()) {
                    g_diag.error(kw_loc,
                                 "Unexpected " +
                                 to_string(kw) +
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
                                 to_string(kw) +
                                 " does not match " +
                                 to_string(open_kw));
                    g_diag.note(open_loc, to_string(open_kw) +
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
                if (!parse_params(pl, params, has_parens)) {
                    return false; // error already reported
                }

                for (StringInterner::Id id : params) {
                    if (std::find(out_locals.begin(), out_locals.end(), id) ==
                            out_locals.end()) {
                        out_locals.push_back(id);
                    }
                }

                if (!pl.check_end_of_line()) {
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
                 to_string(top.first == Keyword::MACRO ?
                           Keyword::ENDM : Keyword::ENDR) +
                 " for " + to_string(top.first));
    return false;
}

// Helper: collect remaining tokens until EndOfLine, expand macros.
// Returns expanded tokens, or empty vector on error (with error reported).
std::vector<Token> Preproc::collect_and_expand_line(
    ParseLine& pline,
    Keyword kw,
    std::string_view what) {

    SourceLoc start_loc = pline.peek().loc;

    // Collect tokens until EndOfLine
    std::vector<Token> raw_tokens;
    while (pline.peek().type != TokenType::EndOfLine &&
            pline.pos < pline.tokens.size()) {
        raw_tokens.push_back(pline.peek());
        pline.advance();
    }

    if (raw_tokens.empty()) {
        g_diag.error(start_loc,
                     "Expected " + std::string(what) +
                     " after " + to_string(kw));
        return {};
    }

    // Expand macros
    LogicalLine line(raw_tokens.front().loc);
    line.tokens = std::move(raw_tokens);
    std::vector<Token> expanded;
    expand_line(line, expanded);

    // Check that expansion produced something besides EndOfLine
    if (expanded.empty() ||
            (expanded.size() == 1 && expanded[0].type == TokenType::EndOfLine)) {
        g_diag.error(start_loc,
                     "Expected " + std::string(what) +
                     " after " + to_string(kw));
        return {};
    }

    return expanded;
}

bool Preproc::eval_if_expr(ParseLine& pline,
                           Keyword kw) {
    std::vector<Token> expanded =
        collect_and_expand_line(pline, kw, "expression");

    if (expanded.empty()) {
        return false;  // error already reported
    }

    // evaluate the if condition
    ParseLine expr_pline(expanded);
    int result = 0;
    if (!eval_if_condition(expr_pline,
                           const_symbols, result, /*silent=*/false)) {
        return false;  // error already reported by eval_if_condition
    }

    if (expr_pline.pos >= expanded.size() ||
            expanded[expr_pline.pos].type != TokenType::EndOfLine) {
        g_diag.error(expanded[0].loc,
                     "Unexpected token after " +
                     to_string(kw) + " expression");
        return false;
    }

    return static_cast<bool>(result);
}

bool Preproc::eval_ifdef_name(ParseLine& pline,
                              bool negated,
                              Keyword kw) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " + to_string(kw));
        return false;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    pline.advance();

    if (!pline.check_end_of_line()) {
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
    ParseLine expr_pline(tokens, pos);
    int result = 0;
    if (eval_const_expr(expr_pline,
                        const_symbols, result, /*silent=*/true) &&
            expr_pline.pos < tokens.size() &&
            tokens[expr_pline.pos].type == TokenType::EndOfLine) {
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
                              ParseLine& pline) {
    std::string resolved;
    SourceLoc filename_loc;
    if (!parse_and_resolve_file(pline, kw,
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
                             ParseLine& pline) {
    std::string resolved;
    SourceLoc filename_loc;
    if (!parse_and_resolve_file(pline, kw,
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
                           ParseLine& pline) {
    size_t line = 0;
    std::string filename;
    if (!parse_LINE_args(pline, kw, line, filename)) {
        return; // error already emitted by parse_LINE_args()
    }

    if (include_stack.empty()) {
        g_diag.error(kw_loc,
                     to_string(kw) +
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
                             ParseLine& pline) {
    size_t line = 0;
    std::string filename;
    if (!parse_LINE_args(pline, kw, line, filename)) {
        return; // error already emitted by parse_LINE_args()
    }

    if (include_stack.empty()) {
        g_diag.error(kw_loc,
                     to_string(kw) +
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
                             ParseLine& pline) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " +
                    to_string(kw));
        return;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    SourceLoc name_loc = pline.peek().loc;
    pline.advance();

    // check if it's a function-like macro, i.e. if next token is '('
    // without space
    bool is_function_like = false;
    bool has_parens = false;
    std::vector<StringInterner::Id> params;
    if (pline.peek().type == TokenType::LeftParen &&
            pline.peek().loc.column ==
            name_loc.column + g_strings.view(name_id).size()) {
        is_function_like = true;
        if (!parse_params(pline, params, has_parens)) {
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
    do_DEFINE(macro, pline);
}

void Preproc::process_name_DEFINE(Keyword, const SourceLoc&,
                                  StringInterner::Id name_id, const SourceLoc& name_loc,
                                  ParseLine& pline) {
    // create the macro and delegate to do_DEFINE
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFINE(macro, pline);
}

void Preproc::do_DEFINE(const Macro& macro,
                        ParseLine& pline) {
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
    if (pline.peek().type == TokenType::EQ) {
        pline.advance(); // skip '='
    }

    // The rest of the line is the replacement list (can be empty)
    std::vector<Token> replacement;
    replacement.reserve(pline.tokens.size() - pline.pos);
    while (pline.peek().type != TokenType::EndOfLine &&
            pline.pos < pline.tokens.size()) {
        replacement.push_back(pline.peek());
        pline.advance();
    }

    // if macro is empty, add a default "1" token
    if (replacement.empty()) {
        replacement.push_back(Token::integer("1", 1, pline.peek().loc));
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
        ParseLine expr_pline(expanded);
        int result = 0;
        if (!expanded.empty() &&
                eval_const_expr(expr_pline,
                                const_symbols, result, /*silent=*/true) &&
                expr_pline.pos < expanded.size() &&
                expanded[expr_pline.pos].type == TokenType::EndOfLine) {
            std::string defc_str =
                "DEFC " +
                g_strings.to_string(macro.name_id) + " = " +
                std::to_string(result);
            std::vector<Token> defc_tokens = tokenize_text(defc_str, line.loc);
            LogicalLine defc_line(line.loc);
            defc_line.tokens = std::move(defc_tokens);

            // do not expand macros again
            assembler_output_queue.push_back(std::move(defc_line));
        }
    }

    // create the macro and insert into the macro table
    Macro new_macro = macro;
    new_macro.tokens = std::move(replacement);
    macros[new_macro.name_id] = std::move(new_macro);
}

void Preproc::process_UNDEF(Keyword kw, const SourceLoc&,
                            ParseLine& pline) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " +
                    to_string(kw));
        return;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    pline.advance();

    if (!pline.check_end_of_line()) {
        return; // error already reported
    }

    do_UNDEF(name_id);
}

void Preproc::process_name_UNDEF(Keyword, const SourceLoc&,
                                 StringInterner::Id name_id, const SourceLoc&,
                                 ParseLine& pline) {
    if (!pline.check_end_of_line()) {
        return; // error already reported
    }

    do_UNDEF(name_id);
}

void Preproc::do_UNDEF(StringInterner::Id name_id) {
    // remove from macro table
    macros.erase(name_id);
}

void Preproc::process_DEFL(Keyword kw, const SourceLoc&,
                           ParseLine& pline) {
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " +
                    to_string(kw));
        return;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    SourceLoc name_loc = pline.peek().loc;
    pline.advance();

    // check if it's a function-like macro, i.e. if next token is '('
    // without space
    if (pline.peek().type == TokenType::LeftParen &&
            pline.peek().loc.column ==
            name_loc.column + g_strings.view(name_id).size()) {
        g_diag.error(pline.peek().loc,
                     to_string(kw) +
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

    do_DEFL(macro, pline);
}

void Preproc::process_name_DEFL(Keyword, const SourceLoc&,
                                StringInterner::Id name_id, const SourceLoc& name_loc,
                                ParseLine& pline) {
    Macro macro;
    macro.name_id = name_id;
    macro.loc = name_loc;
    macro.params.clear();
    macro.is_function_like = false;
    macro.is_multiline = false;

    do_DEFL(macro, pline);
}

void Preproc::do_DEFL(const Macro& macro,
                      ParseLine& pline) {
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
    if (pline.peek().type == TokenType::EQ) {
        pline.advance(); // skip '='
    }

    // The rest of the line is the replacement list (can be empty)
    std::vector<Token> replacement;
    replacement.reserve(pline.tokens.size() - pline.pos);
    while (pline.peek().type != TokenType::EndOfLine &&
            pline.pos < pline.tokens.size()) {
        replacement.push_back(pline.peek());
        pline.advance();
    }

    // if macro is empty, add a default "1" token
    if (replacement.empty()) {
        replacement.push_back(Token::integer("1", 1, pline.peek().loc));
    }

    // Expand body so stored value reflects current expansions
    // (including previous value of <name> if referenced).
    LogicalLine line(replacement.front().loc);
    line.tokens = replacement;
    std::vector<Token> expanded;
    expand_line(line, expanded);

    // if replacement is a constant expression, replace it by its value
    ParseLine expr_pline(expanded);
    int result = 0;
    if (!expanded.empty() &&
            eval_const_expr(expr_pline,
                            const_symbols, result, /*silent=*/true) &&
            expr_pline.pos < expanded.size() &&
            expanded[expr_pline.pos].type == TokenType::EndOfLine) {
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
                            ParseLine& pline) {
    // parse name
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " +
                    to_string(kw));
        return;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    SourceLoc name_loc = pline.peek().loc;
    pline.advance();

    // parse optional parameters
    std::vector<StringInterner::Id> params;
    bool has_parens = false;
    if (!parse_params(pline, params, has_parens)) {
        return; // error already emitted by parse_params()
    }

    // check for end of line
    if (!pline.check_end_of_line()) {
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
                                 ParseLine& pline) {
    // parse optional parameters
    std::vector<StringInterner::Id> params;
    bool has_parens = false;
    if (!parse_params(pline, params, has_parens)) {
        return; // error already emitted by parse_params()
    }

    // check for end of line
    if (!pline.check_end_of_line()) {
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
                           ParseLine&) {
    g_diag.error(kw_loc,
                 "Unexpected " + to_string(kw) + " directive");
}

void Preproc::process_REPT(Keyword kw, const SourceLoc& kw_loc,
                           ParseLine& pline) {
    // Collect and expand the count expression
    std::vector<Token> expanded =
        collect_and_expand_line(pline, kw, "repeat count");

    if (expanded.empty()) {
        return;  // error already reported
    }

    // Evaluate constant expression (not silent -> errors are reported)
    ParseLine expr_pline(expanded);
    int repeat_count = 0;
    if (!eval_const_expr(expr_pline,
                         const_symbols, repeat_count, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    // Check no extra tokens after the expression
    if (expr_pline.pos < expanded.size() &&
            expanded[expr_pline.pos].type != TokenType::EndOfLine) {
        g_diag.error(expanded[expr_pline.pos].loc,
                     "Unexpected token after " +
                     to_string(kw) +
                     " count: " +
                     escape_string(g_strings.to_string(expanded[expr_pline.pos].text_id)));
        return;
    }

    // Read the body lines until ENDR
    std::vector<LogicalLine> body;
    std::vector<StringInterner::Id> locals;
    if (!read_macro_body(kw, kw_loc, body, locals)) {
        return;  // error already emitted by read_macro_body()
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
                           ParseLine&) {
    g_diag.error(kw_loc,
                 "Unexpected " + to_string(kw) + " directive");
}

void Preproc::process_REPTI(Keyword kw, const SourceLoc& kw_loc,
                            ParseLine& pline) {
    // read identifier for iteration variable
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " +
                    to_string(kw));
        return;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    SourceLoc name_loc = pline.peek().loc;
    pline.advance();

    // read comma after identifier
    if (pline.peek().type != TokenType::Comma) {
        pline.error("Expected comma after identifier in " +
                    to_string(kw));
        return;
    }
    pline.advance();

    do_REPTI(kw, kw_loc, name_id, name_loc, pline);
}

void Preproc::process_name_REPTI(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id name_id, const SourceLoc& name_loc,
                                 ParseLine& pline) {

    do_REPTI(kw, kw_loc, name_id, name_loc, pline);
}

void Preproc::do_REPTI(Keyword kw, const SourceLoc& kw_loc,
                       StringInterner::Id name_id, const SourceLoc&,
                       ParseLine& pline) {
    SourceLoc args_loc = pline.peek().loc;

    // Parse comma-separated macro arguments until EndOfLine.
    // collect_bare_args still uses raw vector+pos; extract them from ParseLine.
    std::vector<std::vector<Token>> args;
    if (!collect_bare_args(pline.tokens, pline.pos, args)) {
        return; // error already emitted by collect_bare_args()
    }

    if (args.empty()) {
        g_diag.error(args_loc,
                     "Expected arguments after " + to_string(kw));
        return;
    }

    // Check end of line
    if (!pline.check_end_of_line()) {
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
                            ParseLine& pline) {
    // read identifier for iteration variable
    if (pline.peek().type != TokenType::Identifier) {
        pline.error("Expected identifier after " + to_string(kw));
        return;
    }

    StringInterner::Id name_id = pline.peek().text_id;
    SourceLoc name_loc = pline.peek().loc;
    pline.advance();

    // read comma after identifier
    if (pline.peek().type != TokenType::Comma) {
        pline.error("Expected comma after identifier in " + to_string(kw));
        return;
    }
    pline.advance();

    do_REPTC(kw, kw_loc, name_id, name_loc, pline);
}

void Preproc::process_name_REPTC(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id name_id, const SourceLoc& name_loc,
                                 ParseLine& pline) {
    do_REPTC(kw, kw_loc, name_id, name_loc, pline);
}

void Preproc::process_name_DEFC(Keyword, const SourceLoc& kw_loc,
                                StringInterner::Id name_id,
                                const SourceLoc&, ParseLine& pline) {
    // create DEFC <name> = <rest of line> and push to output queue
    std::string defc_str = "DEFC " + g_strings.to_string(name_id) + " = ";
    std::vector<Token> defc_tokens = tokenize_text(defc_str, kw_loc);

    // skip optional '='
    if (pline.peek().type == TokenType::EQ) {
        pline.advance();
    }

    // remove end-of-line token from defc_tokens if present, since we will append
    if (!defc_tokens.empty() && defc_tokens.back().type == TokenType::EndOfLine) {
        defc_tokens.pop_back();
    }
    defc_tokens.insert(defc_tokens.end(),
                       pline.tokens.begin() + pline.pos, pline.tokens.end());

    // push line to output queue
    LogicalLine defc_line(kw_loc);
    defc_line.tokens = std::move(defc_tokens);

    // create a macro expansion frame for the DEFC line
    std::deque<LogicalLine> defc_lines{ std::move(defc_line) };
    push_macro_expansion(0, std::move(defc_lines));
}

void Preproc::do_REPTC(Keyword kw, const SourceLoc& kw_loc,
                       StringInterner::Id name_id, const SourceLoc&,
                       ParseLine& pline) {
    // Collect and expand the text expression
    std::vector<Token> expanded =
        collect_and_expand_line(pline, kw, "text");

    if (expanded.empty()) {
        return;  // error already reported
    }

    // Read the body lines until ENDR
    std::vector<LogicalLine> body;
    std::vector<StringInterner::Id> locals;
    if (!read_macro_body(kw, kw_loc, body, locals)) {
        return;  // error already emitted by read_macro_body()
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
        return;  // nothing to iterate
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
                            ParseLine&) {
    g_diag.error(kw_loc,
                 "Unexpected " + to_string(kw) + " directive");
}

void Preproc::process_name_LOCAL(Keyword kw, const SourceLoc& kw_loc,
                                 StringInterner::Id, const SourceLoc&,
                                 ParseLine&) {
    g_diag.error(kw_loc,
                 "Unexpected " + to_string(kw) + " directive");
}

void Preproc::process_EXITM(Keyword kw, const SourceLoc& kw_loc,
                            ParseLine& pline) {
    if (!pline.check_end_of_line()) {
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
                 to_string(kw) + " outside of macro expansion");
}

void Preproc::process_IF(Keyword kw, const SourceLoc& kw_loc,
                         ParseLine& pline) {
    bool cond_value = eval_if_expr(pline, kw);

    ConditionalFrame frame;
    frame.if_loc = kw_loc;
    frame.branch_active = cond_value;
    frame.any_taken = cond_value;
    frame.seen_else = false;
    cond_stack.push_back(std::move(frame));
}

void Preproc::process_ELSEIF(Keyword kw, const SourceLoc& kw_loc,
                             ParseLine& pline) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + to_string(kw) +
                     " directive without matching IF");
        return;
    }

    ConditionalFrame& frame = cond_stack.back();
    if (frame.seen_else) {
        g_diag.error(kw_loc,
                     "Unexpected " + to_string(kw) +
                     " directive after ELSE");
        return;
    }

    bool cond_value = eval_if_expr(pline, kw);
    bool active_now = (!frame.any_taken) && cond_value;
    frame.branch_active = active_now;
    if (active_now) {
        frame.any_taken = true;
    }
}

void Preproc::process_ELSE(Keyword kw, const SourceLoc& kw_loc,
                           ParseLine& pline) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + to_string(kw) +
                     " directive without matching IF");
        return;
    }

    ConditionalFrame& frame = cond_stack.back();
    if (!pline.check_end_of_line()) {
        return;
    }

    if (frame.seen_else) {
        g_diag.error(kw_loc, "Multiple " + to_string(kw) + " in IF block");
    }

    frame.branch_active = !frame.any_taken;
    frame.any_taken = true;
    frame.seen_else = true;
}

void Preproc::process_ENDIF(Keyword kw, const SourceLoc& kw_loc,
                            ParseLine& pline) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + to_string(kw) +
                     " directive without matching IF");
        return;
    }

    if (!pline.check_end_of_line()) {
        return;
    }

    cond_stack.pop_back();
}

void Preproc::process_IFDEF(Keyword kw, const SourceLoc& kw_loc,
                            ParseLine& pline) {
    do_IFDEF_IFNDEF(false, kw, kw_loc, pline);
}

void Preproc::process_IFNDEF(Keyword kw, const SourceLoc& kw_loc,
                             ParseLine& pline) {
    do_IFDEF_IFNDEF(true, kw, kw_loc, pline);
}

void Preproc::do_IFDEF_IFNDEF(bool negated,
                              Keyword kw, const SourceLoc& kw_loc,
                              ParseLine& pline) {
    bool cond = eval_ifdef_name(pline, negated, kw);

    ConditionalFrame frame;
    frame.if_loc = kw_loc;
    frame.branch_active = cond;
    frame.any_taken = cond;
    frame.seen_else = false;
    cond_stack.push_back(std::move(frame));
}

void Preproc::process_ELSEIFDEF(Keyword kw, const SourceLoc& kw_loc,
                                ParseLine& pline) {
    do_ELSEIFDEF_ELSEIFNDEF(false, kw, kw_loc, pline);
}

void Preproc::process_ELSEIFNDEF(Keyword kw, const SourceLoc& kw_loc,
                                 ParseLine& pline) {
    do_ELSEIFDEF_ELSEIFNDEF(true, kw, kw_loc, pline);
}

void Preproc::do_ELSEIFDEF_ELSEIFNDEF(bool negated,
                                      Keyword kw, const SourceLoc& kw_loc,
                                      ParseLine& pline) {
    if (cond_stack.empty()) {
        g_diag.error(kw_loc,
                     "Unexpected " + to_string(kw) +
                     " directive without matching IF");
        return;
    }

    ConditionalFrame& frame = cond_stack.back();
    if (frame.seen_else) {
        g_diag.error(kw_loc,
                     "Unexpected " + to_string(kw) +
                     " directive after ELSE");
        return;
    }

    bool cond = eval_ifdef_name(pline, negated, kw);
    bool active_now = (!frame.any_taken) && cond;
    frame.branch_active = active_now;
    if (active_now) {
        frame.any_taken = true;
    }
}

void Preproc::process_PRAGMA(Keyword, const SourceLoc&,
                             ParseLine& pline) {
    // Reserve PRAGMA for future extensions:
    // only handle "PRAGMA ONCE", ignore anything else.
    if (pline.peek().type != TokenType::Identifier ||
            pline.peek().keyword != Keyword::ONCE) {
        return;
    }

    // consume ONCE
    pline.advance();

    // PRAGMA ONCE must have no extra tokens
    if (!pline.check_end_of_line()) {
        return;
    }

    // PRAGMA ONCE in current file
    if (include_stack.empty() || include_stack.back().file == nullptr) {
        return;
    }

    StringInterner::Id file_id = include_stack.back().file->file_id;
    auto it = std::find(pragma_once_files.begin(), pragma_once_files.end(),
                        file_id);

    if (it != pragma_once_files.end()) {
        // file already marked once -> skip remaining lines of this file
        include_stack.pop_back();
    }
    else {
        // first time this file requests PRAGMA ONCE
        pragma_once_files.push_back(file_id);
    }
}

void Preproc::process_ASSERT(Keyword kw, const SourceLoc&,
                             ParseLine& pline) {
    // Collect and expand the assertion expression
    std::vector<Token> expanded =
        collect_and_expand_line(pline, kw, "expression");

    if (expanded.empty()) {
        return;  // error already reported
    }

    // Evaluate constant expression
    const SourceLoc expr_loc = expanded.front().loc;
    ParseLine expr_pline(expanded);
    int result = 0;
    if (!eval_const_expr(expr_pline,
                         const_symbols, result, /*silent=*/false)) {
        return;  // syntax/non-constant errors already reported
    }

    // Optional: , "message"
    std::string message;
    if (expr_pline.pos < expanded.size() &&
            expanded[expr_pline.pos].type == TokenType::Comma) {
        ++expr_pline.pos;

        if (expr_pline.pos >= expanded.size() ||
                expanded[expr_pline.pos].type != TokenType::String) {
            SourceLoc err_loc = (expr_pline.pos < expanded.size())
                                ? expanded[expr_pline.pos].loc
                                : expanded.back().loc;
            g_diag.error(err_loc,
                         "Expected string after comma in " +
                         to_string(kw));
            return;
        }

        message = g_strings.to_string(expanded[expr_pline.pos].value.str_value_id);
        ++expr_pline.pos;
    }

    // Must end at EOL
    if (expr_pline.pos < expanded.size() &&
            expanded[expr_pline.pos].type != TokenType::EndOfLine) {
        g_diag.error(expanded[expr_pline.pos].loc,
                     "Unexpected token after " + to_string(kw));
        return;
    }

    // Assertion passed
    if (result != 0) {
        return;
    }

    // Assertion failed
    g_diag.error(expr_loc, message.empty() ? "Assertion failed" : message);
}

void Preproc::process_ERROR(Keyword, const SourceLoc&,
                            ParseLine& pline) {
    // Optional: ERROR "message"
    std::string message = "User specified error";
    SourceLoc err_loc = pline.peek().loc;

    if (pline.peek().type == TokenType::String) {
        message = g_strings.to_string(pline.peek().value.str_value_id);
        err_loc = pline.peek().loc;
        ++pline.pos;
    }

    // Must end at EOL (or only have EOL tokens left)
    if (!pline.check_end_of_line()) {
        return;
    }

    g_diag.error(err_loc, message);
}

void Preproc::process_ASSUME(Keyword kw, const SourceLoc& kw_loc,
                             ParseLine& pline) {
    if (pline.peek().keyword != Keyword::ADL) {
        pline.error("Expected ADL after " + to_string(kw));
        return;
    }
    pline.advance(); // consume ADL

    if (pline.peek().type != TokenType::EQ) {
        pline.error("Expected '=' after " + to_string(kw) + " ADL");
        return;
    }
    pline.advance(); // consume '='

    if (pline.peek().type != TokenType::Integer ||
            (pline.peek().value.int_value != 0 && pline.peek().value.int_value != 1)) {
        pline.error("Expected 0/1 after " + to_string(kw) + " ADL =");
        return;
    }
    bool adl_value = (pline.peek().value.int_value != 0);
    pline.advance(); // consume integer

    if (!pline.check_end_of_line()) {
        return;
    }

    do_ASSUME(adl_value, kw_loc);
}

void Preproc::do_ASSUME(bool adl_value, const SourceLoc& kw_loc) {
    // check if ADL mode is valid
    if (!cpu_set_adl_mode(preproc_cpu_id, adl_value)) {
        g_diag.error(kw_loc,
                     "CPU " + cpu_name(preproc_cpu_id) + " does not support ADL mode");
        return;
    }

    // change constants for CPU
    for (auto& var : cpu_all_defines()) {
        StringInterner::Id var_id = g_strings.intern(var);
        const_symbols.erase(var_id);
    }
    for (auto& var : cpu_defines(preproc_cpu_id)) {
        StringInterner::Id var_id = g_strings.intern(var);
        const_symbols.set(var_id, 1, SourceLoc());
    }

    // create PRAGMA CPU_ADL 0/1 and push to output queue
    std::string pragma_str = "PRAGMA CPU_ADL " + std::to_string(adl_value);
    std::vector<Token> pragma_tokens = tokenize_text(pragma_str, kw_loc);

    // push line to output queue
    LogicalLine pragma_line(kw_loc);
    pragma_line.tokens = std::move(pragma_tokens);

    // do not expand macros again
    assembler_output_queue.push_back(std::move(pragma_line));
}

void Preproc::process_Z88_CALL_OZ(Keyword kw, const SourceLoc& kw_loc,
                                  ParseLine& pline) {
    // Collect and expand the OZ instruction argument expression
    std::vector<Token> expanded = collect_and_expand_line(pline, kw, "argument");
    if (expanded.empty()) {
        return;  // error already reported
    }

    // Evaluate constant expression (not silent -> errors are reported)
    int arg_value = 0;
    ParseLine expr_pline(expanded);
    if (!eval_const_expr(expr_pline,
                         const_symbols, arg_value, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    if (!expr_pline.check_end_of_line()) {
        return; // error already reported by check_end_of_line
    }

    // check argument range
    std::string data_opc;
    if (arg_value >= 0 && arg_value <= 0xFF) {
        data_opc = "DEFB";
    }
    else if (arg_value >= 0x100 && arg_value <= 0xFFFF) {
        data_opc = "DEFW";
    }
    else {
        g_diag.error(expanded.front().loc,
                     "Argument out of range for " + to_string(kw) + ": " + int_to_hex(arg_value));
        return;
    }

    // macros already expanded, send directly to assembler output queue
    // first line: RST $20
    std::string rst_str = "RST $20";
    std::vector<Token> rst_tokens = tokenize_text(rst_str, kw_loc);
    LogicalLine rst_line(kw_loc);
    rst_line.tokens = std::move(rst_tokens);
    assembler_output_queue.push_back(std::move(rst_line));

    // second line: DEFB | DEFW <argument>
    std::string def_str = data_opc + " " + std::to_string(arg_value);
    std::vector<Token> def_tokens = tokenize_text(def_str, kw_loc);
    LogicalLine def_line(kw_loc);
    def_line.tokens = std::move(def_tokens);
    assembler_output_queue.push_back(std::move(def_line));
}

void Preproc::process_Z88_CALL_PKG(Keyword kw, const SourceLoc& kw_loc,
                                   ParseLine& pline) {
    // Collect and expand the PKG instruction argument expression
    std::vector<Token> expanded = collect_and_expand_line(pline, kw, "argument");
    if (expanded.empty()) {
        return;  // error already reported
    }

    // Evaluate constant expression (not silent -> errors are reported)
    int arg_value = 0;
    ParseLine expr_pline(expanded);
    if (!eval_const_expr(expr_pline,
                         const_symbols, arg_value, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    if (!expr_pline.check_end_of_line()) {
        return; // error already reported by check_end_of_line
    }

    // Rabbit's don't have RST $08
    if (preproc_cpu_id == CPU::r2ka || preproc_cpu_id == CPU::r2ka_strict ||
            preproc_cpu_id == CPU::r3k || preproc_cpu_id == CPU::r3k_strict ||
            preproc_cpu_id == CPU::r4k || preproc_cpu_id == CPU::r4k_strict ||
            preproc_cpu_id == CPU::r5k || preproc_cpu_id == CPU::r5k_strict ||
            preproc_cpu_id == CPU::r6k || preproc_cpu_id == CPU::r6k_strict) {
        g_diag.error(expanded.front().loc,
                     "CPU " + cpu_name(preproc_cpu_id) + " does not support " + to_string(kw));
        return;
    }

    // check argument range
    if (arg_value < 0 || arg_value > 0xFFFF) {
        g_diag.error(expanded.front().loc,
                     "Argument out of range for " + to_string(kw) + ": " + int_to_hex(arg_value));
        return;
    }

    // macros already expanded, send directly to assembler output queue
    // first line: RST $08
    std::string rst_str = "RST $08";
    std::vector<Token> rst_tokens = tokenize_text(rst_str, kw_loc);
    LogicalLine rst_line(kw_loc);
    rst_line.tokens = std::move(rst_tokens);
    assembler_output_queue.push_back(std::move(rst_line));

    // second line: DEFB | DEFW <argument>
    std::string def_str = "DEFW " + std::to_string(arg_value);
    std::vector<Token> def_tokens = tokenize_text(def_str, kw_loc);
    LogicalLine def_line(kw_loc);
    def_line.tokens = std::move(def_tokens);
    assembler_output_queue.push_back(std::move(def_line));
}

void Preproc::do_CU_fixed(Keyword, const SourceLoc& kw_loc, ParseLine& pline,
                          int value) {
    if (!pline.check_end_of_line()) {
        return;
    }

    // create a CU_xxxx statement with the fixed value as argument
    // and send it to the assembler output queue
    std::string cu_op_str = "DEFW_BE " + int_to_hex(value);
    std::vector<Token> cu_op_tokens = tokenize_text(cu_op_str, kw_loc);

    LogicalLine cu_op_line(kw_loc);
    cu_op_line.tokens = std::move(cu_op_tokens);
    assembler_output_queue.push_back(std::move(cu_op_line));
}

void Preproc::process_CU_WAIT(Keyword kw, const SourceLoc& kw_loc,
                              ParseLine& pline) {
    // Collect and expand the CU_WAIT instruction argument expression
    std::vector<Token> expanded = collect_and_expand_line(pline, kw, "argument");
    if (expanded.empty()) {
        return;  // error already reported
    }

    // evaluate ver_value argument
    ParseLine expr_pline(expanded);
    int ver_value = 0;
    SourceLoc ver_loc = expr_pline.peek().loc;
    if (!eval_const_expr(expr_pline,
                         const_symbols, ver_value, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    if (expr_pline.peek().type != TokenType::Comma) {
        g_diag.error(expr_pline.peek().loc,
                     "Expected comma after expression in " + to_string(kw));
        return;
    }
    expr_pline.advance(); // consume comma

    // evaluate hor_value argument
    int hor_value = 0;
    SourceLoc hor_loc = expr_pline.peek().loc;
    if (!eval_const_expr(expr_pline,
                         const_symbols, hor_value, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    if (!expr_pline.check_end_of_line()) {
        return; // error already reported by check_end_of_line
    }

    // check argument range and compute value
    int argument = 0;
    if (!compute_cu_wait_value(argument, preproc_cpu_id,
                               ver_value, hor_value, kw_loc, ver_loc, hor_loc)) {
        return; // error already reported by compute_cu_wait_value
    }
    do_CU_fixed(kw, kw_loc, pline, argument);
}

void Preproc::process_CU_MOVE(Keyword kw, const SourceLoc& kw_loc,
                              ParseLine& pline) {
    // Collect and expand the CU_MOVE instruction argument expression
    std::vector<Token> expanded = collect_and_expand_line(pline, kw, "argument");
    if (expanded.empty()) {
        return;  // error already reported
    }

    // evaluate reg_value argument
    ParseLine expr_pline(expanded);
    int reg_value = 0;
    SourceLoc reg_loc = expr_pline.peek().loc;
    if (!eval_const_expr(expr_pline,
                         const_symbols, reg_value, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    if (expr_pline.peek().type != TokenType::Comma) {
        g_diag.error(expr_pline.peek().loc,
                     "Expected comma after expression in " + to_string(kw));
        return;
    }
    expr_pline.advance(); // consume comma

    // evaluate value argument
    int value = 0;
    SourceLoc value_loc = expr_pline.peek().loc;
    if (!eval_const_expr(expr_pline,
                         const_symbols, value, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    if (!expr_pline.check_end_of_line()) {
        return; // error already reported by check_end_of_line
    }

    // check argument range and compute value
    int argument = 0;
    if (!compute_cu_move_value(argument, preproc_cpu_id,
                               reg_value, value, kw_loc, reg_loc, value_loc)) {
        return; // error already reported by compute_cu_move_value
    }
    do_CU_fixed(kw, kw_loc, pline, argument);
}

void Preproc::process_CU_STOP(Keyword kw, const SourceLoc& kw_loc,
                              ParseLine& pline) {
    int argument = 0;
    if (!compute_cu_stop_value(argument, preproc_cpu_id, kw_loc)) {
        return; // error already reported by compute_cu_stop_value
    }

    do_CU_fixed(kw, kw_loc, pline, argument);
}

void Preproc::process_CU_NOP(Keyword kw, const SourceLoc& kw_loc,
                             ParseLine& pline) {
    int argument = 0;
    if (!compute_cu_nop_value(argument, preproc_cpu_id, kw_loc)) {
        return; // error already reported by compute_cu_nop_value
    }

    do_CU_fixed(kw, kw_loc, pline, argument);
}

void Preproc::process_DEFGROUP(Keyword kw, const SourceLoc& kw_loc,
                               ParseLine& pline) {
    // expand macros in the { } block first, since the definitions may call macros
    std::vector<Token> expanded;
    expand_braces_block(kw, kw_loc, pline, expanded);

    // need to collect all DEFC statements in a list, because next_logical_line() will retrieve
    // from assembler_output_queue
    std::vector<LogicalLine> output;

    // now parse the expanded tokens as a sequence of "name [= value]" pairs
    ParseLine expline(expanded);
    int value = 0;
    while (!expline.eol()) {
        // skip commas between definitions
        if (expline.peek().type == TokenType::Comma) {
            expline.advance(); // skip comma
            continue;
        }

        // must have a identifier for the name
        if (expline.peek().type != TokenType::Identifier) {
            expline.error("Expected identifier in " + to_string(kw) + " directive");
            return;
        }
        std::string name = g_strings.to_string(expline.peek().text_id);
        SourceLoc name_loc = expline.peek().loc;
        expline.advance();

        // check for optional "= value" after the name
        if (expline.peek().type == TokenType::EQ) {
            expline.advance(); // consume '='

            // evaluate expression and overwrite value if valid
            if (!eval_const_expr(expline, const_symbols, value, /*silent=*/false)) {
                return;  // error already reported by eval_const_expr
            }
        }

        // now produce a DEFC <name> = <value> line for this definition and push to output queue
        std::string defc_str = "DEFC " + name + " = " + std::to_string(value);
        std::vector<Token> defc_tokens = tokenize_text(defc_str, name_loc);
        LogicalLine defc_line(name_loc);
        defc_line.tokens = std::move(defc_tokens);

        // collect in output vector first, since pushing to assembler_output_queue will
        // cause next_logical_line() to retrieve them
        output.push_back(std::move(defc_line));

        // increment value for the next definition
        ++value;

        // must have a comma (skipped at the top) or end of line after each definition
        if (!expline.eol() && expline.peek().type != TokenType::Comma) {
            expline.error("Expected ',' or end of line in " + to_string(kw) + " directive");
            return;
        }
    }

    // output now contains all DEFC lines for the group, with macros expanded
    for (auto& defc_line : output) {
        // do not expand macros again
        assembler_output_queue.push_back(std::move(defc_line));
    }
}

void Preproc::process_DEFVARS(Keyword kw, const SourceLoc& kw_loc,
                              ParseLine& pline) {
    // expression after DEFVARS keyword determines the origin of the variables in this block:
    int origin = 0;

    // Collect and expand the origin expression
    std::vector<Token> expanded = collect_and_expand_line(pline, kw, "origin");
    if (expanded.empty()) {
        return;  // error already reported
    }

    // Evaluate constant expression (not silent -> errors are reported)
    ParseLine expr_pline(expanded);
    if (!eval_const_expr(expr_pline,
                         const_symbols, origin, /*silent=*/false)) {
        return;  // error already reported by eval_const_expr
    }

    bool has_origin_error = false;

    // Case A - DEFVARS <expr> with <expr> > 0
    // Start a new non-zero struct:
    if (origin > 0) {
        defvars_state.current_offset = origin;
        defvars_state.have_current = true;

        // this struct is now the "last non-zero struct"
        defvars_state.last_nonzero_offset = origin;
        defvars_state.have_last_nonzero = true;
    }
    // Case B - DEFVARS 0
    // Start a stand-alone struct that does not participate in continuation:
    else if (origin == 0) {
        defvars_state.current_offset = 0;
        defvars_state.have_current = true;
        // do NOT touch last_nonzero_* here
    }
    // Case C - DEFVARS -1
    // This means "continue the last non-zero struct":
    else if (origin == -1) {
        if (!defvars_state.have_last_nonzero) {
            g_diag.error(kw_loc, "DEFVARS -1 with no previous non-zero DEFVARS");

            // must exit after parsing the block
            // to avoid cascading errors on the definitions
            has_origin_error = true;
        }

        defvars_state.current_offset = defvars_state.last_nonzero_offset;
        defvars_state.have_current = true;
    }
    else {
        g_diag.error(kw_loc, "Invalid origin for " + to_string(kw) +
                     ": must be -1, 0, or a positive integer");

        // must exit after parsing the block
        // to avoid cascading errors on the definitions
        has_origin_error = true;
    }

    // now parse the block between '{' and '}' and push DEFC lines to the output queue
    // with the variable names and offsets
    std::vector<LogicalLine> output;
    parse_DEFVARS_block(kw, kw_loc, expr_pline, output);

    if (has_origin_error) {
        return; // do not update state or push output if there was an origin error
    }

    // at the end of the block
    // Case A or C - if we had a non-zero origin, record the last non-zero offset
    // for potential continuation by a later DEFVARS with origin -1
    if (origin != 0) {
        defvars_state.last_nonzero_offset = defvars_state.current_offset;
        defvars_state.have_last_nonzero = true;
    }

    // output now contains all DEFC lines for the group, with macros expanded
    for (auto& defc_line : output) {
        // do not expand macros again
        assembler_output_queue.push_back(std::move(defc_line));
    }
}

void Preproc::parse_DEFVARS_block(Keyword kw, const SourceLoc& kw_loc,
                                  ParseLine& pline, std::vector<LogicalLine>& output) {
    // expand macros in the { } block first, since the definitions may call macros
    std::vector<Token> expanded;
    expand_braces_block(kw, kw_loc, pline, expanded);

    // now parse the expanded tokens as a sequence of "[name] DS.[B|W|P|Q] count"
    ParseLine expline(expanded);
    while (!expline.eol()) {
        // skip commas between definitions
        if (expline.peek().type == TokenType::Comma) {
            expline.advance(); // skip comma
            continue;
        }

        // must have either a name or DS keyword
        if (expline.peek().type != TokenType::Identifier) {
            expline.error("Expected identifer or DS keyword in " + to_string(
                              kw) + " directive");
            return;
        }

        // optional identifier for the name
        StringInterner::Id name_id = 0;
        SourceLoc name_loc;
        if (expline.peek().keyword != Keyword::DS) {
            name_id = expline.peek().text_id;
            name_loc = expline.peek().loc;
            expline.advance();
        }

        // must have DS keyword a Dot and a size specifier
        if (expline.peek().keyword != Keyword::DS) {
            expline.error("Expected DS keyword in " + to_string(kw) + " directive");
            return;
        }
        expline.advance(); // consume DS

        if (expline.peek().type != TokenType::Dot) {
            expline.error("Expected '.' after DS in " + to_string(kw) + " directive");
            return;
        }
        expline.advance(); // consume '.'

        int size = 0;
        switch (expline.peek().keyword) {
        case Keyword::B:
            size = 1;
            expline.advance(); // consume size specifier
            break;
        case Keyword::W:
            size = 2;
            expline.advance(); // consume size specifier
            break;
        case Keyword::P:
            size = 3;
            expline.advance(); // consume size specifier
            break;
        case Keyword::Q:
            size = 4;
            expline.advance(); // consume size specifier
            break;
        default:
            expline.error("Expected size specifier (.B, .W, .P, or .Q) after DS in " +
                          to_string(kw) + " directive");
            return;
        }

        // parse count expression
        int count = 0;
        if (!eval_const_expr(expline, const_symbols, count, /*silent=*/false)) {
            return;  // error already reported by eval_const_expr
        }
        if (count < 0) {
            expline.error("Count expression must be zero or positive in " + to_string(
                              kw) + " directive");
            return;
        }

        // emit DEFC for each given name in the definition, with the appropriate offset
        if (name_id != 0) {
            std::string var_name = g_strings.to_string(name_id);
            std::string defc_str = "DEFC " + var_name + " = " +
                                   std::to_string(defvars_state.current_offset);
            std::vector<Token> defc_tokens = tokenize_text(defc_str, name_loc);
            LogicalLine defc_line(name_loc);
            defc_line.tokens = std::move(defc_tokens);

            // collect in output vector first, since pushing to assembler_output_queue will
            // cause next_logical_line() to retrieve them
            output.push_back(std::move(defc_line));
        }

        // advance the offset by the size of the variable(s) we just defined
        defvars_state.current_offset += size * count;

        // must have a comma (skipped at the top) or end of line after each definition
        if (!expline.eol() && expline.peek().type != TokenType::Comma) {
            expline.error("Expected ',' or end of line in " + to_string(kw) + " directive");
            return;
        }
    }
}

void Preproc::expand_braces_block(Keyword kw, const SourceLoc& kw_loc,
                                  ParseLine& pline, std::vector<Token>& output) {
    // need to collect LogicalLines (which own the tokens) for each new line
    // retrieved by next_logical_line()
    ParseLine* cur = &pline;
    std::vector<LogicalLine> temp_lines;  // owns the token vectors
    std::vector<ParseLine> temp_parselines;  // references into temp_lines

    // need to collect all tokens up to '}' and expand macros in them,
    // since the DEFGROUP and DEFVARS definitions may call macros
    std::vector<Token> tokens;

    // parse input between '{' and '}', allowing multiple lines until we find the closing '}'
    bool found_opening_brace = false;
    bool found_closing_brace = false;
    while (!found_closing_brace) {
        const Token& tok = cur->peek();
        if (tok.type == TokenType::EndOfLine) {
            // treat newlines as commas to separate definitions
            tokens.push_back(Token::token(TokenType::Comma, ",", tok.loc));

            // read the next line and continue
            LogicalLine ll;
            SourceLoc prev_loc = tok.loc;
            if (!next_logical_line(ll)) {
                g_diag.error(prev_loc,
                             "Unexpected end of file in " + to_string(kw) + " directive");
                return;
            }

            // Store the LogicalLine (which owns the tokens)
            temp_lines.push_back(std::move(ll));

            // Create a ParseLine referencing the tokens in the stored LogicalLine
            temp_parselines.emplace_back(temp_lines.back().tokens);

            cur = &temp_parselines.back();
            continue;
        }

        if (tok.type == TokenType::LeftBrace) {
            if (found_opening_brace) {
                cur->error("Multiple '{' in " + to_string(kw) + " directive");
                return;
            }
            found_opening_brace = true;
            cur->advance(); // consume '{'
            continue;
        }

        if (tok.type == TokenType::RightBrace) {
            if (!found_opening_brace) {
                cur->error("Unexpected '}' in " + to_string(kw) + " directive");
                return;
            }
            found_closing_brace = true;
            cur->advance(); // consume '}'
            continue;
        }

        if (!found_opening_brace) {
            cur->error("Missing '{' in " + to_string(kw) + " directive");
            return;
        }

        tokens.push_back(tok);
        cur->advance();
    }

    if (!cur->check_end_of_line()) {
        return;
    }

    // tokens now contains all tokens between '{' and '}', with macros unexpanded
    // let's expand them now
    LogicalLine in(kw_loc);
    in.tokens = std::move(tokens);

    output.clear();
    expand_line(in, output);
}

void Preproc::expand_args_multiline(Keyword kw, const SourceLoc& kw_loc,
                            ParseLine& pline, std::vector<Token>& output) {
    // need to collect LogicalLines (which own the tokens) for each new line
    // retrieved by next_logical_line()
    ParseLine* cur = &pline;
    std::vector<LogicalLine> temp_lines;  // owns the token vectors
    std::vector<ParseLine> temp_parselines;  // references into temp_lines

    // need to collect all tokens up to a line not terminating in comma
    // and expand macros in them, to parse multi-line DMA arguments
    std::vector<Token> tokens;

    while (true) {
        const Token& tok = cur->peek();
        if (tok.type == TokenType::EndOfLine) {
            if (tokens.empty() || tokens.back().type != TokenType::Comma) {
                // a real end of line
                tokens.push_back(tok);
                break;
            }
            else {
                // last was comma, so skip EndOfLine and read new line
                LogicalLine ll;
                SourceLoc prev_loc = tok.loc;
                if (!next_logical_line(ll)) {
                    g_diag.error(prev_loc,
                                "Unexpected end of file in " + to_string(kw) + " directive");
                    return;
                }

                // Store the LogicalLine (which owns the tokens)
                temp_lines.push_back(std::move(ll));

                // Create a ParseLine referencing the tokens in the stored LogicalLine
                temp_parselines.emplace_back(temp_lines.back().tokens);

                cur = &temp_parselines.back();
                continue;
            }
        }
        else {
            tokens.push_back(tok);
            cur->advance();
        }
    }

    if (!cur->check_end_of_line()) {
        return;
    }

    // tokens now contains all multi-line arguments, with macros unexpanded
    // let's expand them now
    LogicalLine in(kw_loc);
    in.tokens = std::move(tokens);

    output.clear();
    expand_line(in, output);
}

void Preproc::process_DMA(Keyword kw, const SourceLoc& kw_loc,
                          ParseLine& pline) {
    // Collect and expand the DMA instruction argument expressions
    std::vector<Token> expanded;
    expand_args_multiline(kw, kw_loc, pline, expanded);
    if (expanded.empty()) {
        return;  // error already reported
    }

    ParseLine expr_pline(expanded);
    std::vector<std::pair<int, SourceLoc>> val_loc_data;
    while (true) {
        int value = 0;
        SourceLoc value_loc = expr_pline.peek().loc;
        if (!eval_const_expr(expr_pline,
                             const_symbols, value, /*silent=*/false)) {
            return;  // error already reported by eval_const_expr
        }
        val_loc_data.emplace_back(value, value_loc);

        if (expr_pline.peek().type == TokenType::Comma) {
            expr_pline.advance(); // consume comma and continue parsing arguments
        }
        else if (expr_pline.peek().type == TokenType::EndOfLine) {
            break; // end of arguments
        }
        else {
            g_diag.error(expr_pline.peek().loc,
                         "Expected comma or end of line after expression in " + to_string(kw));
            return;
        }
    }

    if (!expr_pline.check_end_of_line()) {
        return; // error already reported by check_end_of_line
    }

    // produce list of DEFB/DEFW lines
    std::vector<std::pair<int, int>> size_val_data;
    if (!compute_dma_data(size_val_data, preproc_cpu_id, val_loc_data, kw,
                          kw_loc)) {
        return; // error already reported by compute_dma_data
    }

    // macros already expanded, send directly to assembler output queue
    for (const auto& [size, value] : size_val_data) {
        std::string data_opc;
        if (size == 1) {
            data_opc = "DEFB";
        }
        else if (size == 2) {
            data_opc = "DEFW";
        }
        else {
            assert(0);
        }

        std::string def_str = data_opc + " " + std::to_string(value);
        std::vector<Token> def_tokens = tokenize_text(def_str, kw_loc);
        LogicalLine def_line(kw_loc);
        def_line.tokens = std::move(def_tokens);
        assembler_output_queue.push_back(std::move(def_line));
    }
}

//-----------------------------------------------------------------------------
// main driver for directive processing:
// classifies line and dispatches to handlers
//-----------------------------------------------------------------------------

Preproc::LineType Preproc::process_directive_line(
    const std::vector<Token>& pline,
    LogicalLine& out_line) {
    out_line.tokens.clear();
    out_line.loc = pline.empty() ? SourceLoc{} :
                   pline[0].loc;

    // ---------------------------------------------------------------------
    // 1. Find first non-EndOfLine token
    // ---------------------------------------------------------------------
    ParseLine pl(pline);
    while (pl.peek().type == TokenType::EndOfLine &&
            pl.pos < pl.tokens.size()) {
        ++pl.pos;
    }

    if (pl.pos >= pl.tokens.size()) {
        // Empty line -> normal line (macro expander will append EOL)
        return LineType::Normal;
    }

    const Token& first_tok = pl.peek();

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

    if (!is_directive(pl, kw, kw_loc, name_id, name_loc)) {
        // Not a directive
        if (!cond_active) {
            return LineType::Skip;
        }

        out_line.tokens = pline;
        rewrite_logical_line(out_line);
        return LineType::Normal;
    }

    // ---------------------------------------------------------------------
    // 4. Dispatch to directive handlers
    // ---------------------------------------------------------------------

    // ---------------------------------------------------------------------
    // If conditional block inactive, ignore all other directives
    // ---------------------------------------------------------------------
    if (!is_conditional_directive_keyword(kw) && !cond_active) {
        return LineType::Skip;
    }

    // ---------------------------------------------------------------------
    // Non-conditional directives
    // ---------------------------------------------------------------------
    if (name_id == 0) {
        // Handle normal directives starting with directive keyword
        auto it = directive_handlers.find(kw);
        if (it != directive_handlers.end()) {
            (this->*it->second)(kw, kw_loc, pl);
            return LineType::ControlOnly;
        }

        it = conditional_handlers.find(kw);
        if (it != conditional_handlers.end()) {
            (this->*it->second)(kw, kw_loc, pl);
            return LineType::ControlOnly;
        }
    }
    else {
        // Handle "name DEFINE 1" style directives with name
        // before directive keyword
        auto it = name_directive_handlers.find(kw);
        if (it != name_directive_handlers.end()) {
            (this->*it->second)(kw, kw_loc, name_id, name_loc, pl);
            return LineType::ControlOnly;
        }
    }

    // ---------------------------------------------------------------------
    // Unknown directive -> error
    // ---------------------------------------------------------------------
    g_diag.error(first_tok.loc, "Unknown preprocessor directive: " +
                 to_string(kw));
    return LineType::ControlOnly;
}
