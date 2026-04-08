//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "file_mgr.h"
#include "lexer.h"
#include "lexer_keywords.h"
#include "lexer_scan.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cassert>
#include <cstring>
#include <iostream>
#include <string>
#include <utility>

std::string tokens_to_string(const std::vector<Token>& tokens) {
    auto concat = [](const std::string & s1, const std::string & s2) {
        if (s1.empty() || s2.empty()) {
            return s1 + s2;
        }
        else if (ends_with(s1, "##")) {   // cpp-style concatenation
            return s1.substr(0, s1.length() - 2) + s2;
        }
        else if (is_space(s1.back()) || is_space(s2.front())) {
            return s1 + s2;
        }
        else if (is_ident_char(s1.back()) && is_ident_char(s2.front())) {
            return s1 + " " + s2;
        }
        else if (is_ident_char(s1.back()) && s2.front() == '@') {
            return s1 + " " + s2;
        }
        else if (s1.back() == '$' && is_hex_digit(s2.front())) {
            return s1 + " " + s2;
        }
        else if ((s1.back() == '%' || s1.back() == '@') &&
                 (is_dec_digit(s2.front()) || s2.front() == '"' || is_ident_start(s2.front()))) {
            return s1 + " " + s2;
        }
        else if ((s1.back() == '&' && s2.front() == '&') ||
                 (s1.back() == '|' && s2.front() == '|') ||
                 (s1.back() == '^' && s2.front() == '^') ||
                 (s1.back() == '*' && s2.front() == '*') ||
                 (s1.back() == '<' && (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
                 (s1.back() == '>' && (s2.front() == '=' || s2.front() == '>')) ||
                 (s1.back() == '=' && s2.front() == '=') ||
                 (s1.back() == '!' && s2.front() == '=') ||
                 (s1.back() == '#' && s2.front() == '#')) {
            return s1 + " " + s2;
        }
        else {
            return s1 + s2;
        }
    };

    std::string out;
    for (const Token& token : tokens) {
        switch (token.type) {
        case TokenType::EndOfLine:
            out += '\n';
            break;

        default:
            out = concat(out, g_strings.to_string(token.text_id));
            break;
        }
    }

    return out;
}

static std::string_view get_line_view(const SourceFile& sf,
                                      std::string_view content,
                                      size_t line) {
    size_t off = sf.line_offsets[line];
    size_t len = sf.line_lengths[line];
    return std::string_view(content.data() + off, len);
}

static std::vector<Token> tokenize_line(TokenizeState& state,
                                        std::string_view text,
                                        const SourceLoc& loc) {
    // Build a temporary line
    ScanLine line;
    line.text = text;
    line.locmap.reserve(text.size() + 1);

    int col = loc.column;
    for ([[maybe_unused]] char c : text) {
        line.locmap.emplace_back(loc.file_id, loc.line, col++);
    }

    // Sentinel: one past the last character, for error reporting
    // at end-of-line
    line.locmap.emplace_back(loc.file_id, loc.line, col);

    // Tokenize
    std::vector<Token> tokens;
    tokenize_scan_line(line, state, tokens);

    // End-of-line token: after last token
    SourceLoc end_loc;
    if (!tokens.empty()) {
        const Token& last = tokens.back();
        end_loc.file_id = last.loc.file_id;
        end_loc.line = last.loc.line;
        end_loc.column = last.loc.column +
                         static_cast<uint16_t>(g_strings.to_string(last.text_id).size());
    }
    else {
        end_loc = SourceLoc(loc.file_id, loc.line, loc.column);
    }

    tokens.push_back(Token::end_of_line(end_loc));
    return tokens;
}

void tokenize(SourceFile& sf, std::string_view content) {
    TokenizeState state;
    size_t num_lines = sf.line_offsets.size();

    sf.lines.resize(num_lines);

    // Per-line flag: true if scanning started inside a multi-line comment.
    // Such lines must be merged into the line that opened the comment.
    std::vector<bool> started_in_comment(num_lines, false);

    // Need to tokenize first, and detect continuations afterwards,
    // as a backslash at the end of a line is not a continuation if it's inside
    // a comment
    for (size_t i = 0; i < num_lines; ++i) {
        SourceLoc loc(sf.file_id, i + 1, 1);
        std::string_view text = get_line_view(sf, content, i);

        // Record whether we are inside a comment before scanning
        started_in_comment[i] = state.in_multiline_comment;

        // Use tokenize_line with shared state so multi-line comments
        // are tracked correctly; tokenize_line always appends EndOfLine
        std::vector<Token> tokens = tokenize_line(state, text, loc);

        // store tokens in the line
        sf.lines[i].loc = loc;
        sf.lines[i].tokens = std::move(tokens);
        sf.lines[i].origin = LineOrigin::RawInput;
    }

    if (state.in_multiline_comment) {
        g_diag.error(state.multiline_comment_start,
                     "Unterminated multi-line comment");
    }

    // Now merge lines connected by multi-line comments or backslash
    // continuations.
    //
    // A line that started inside a multi-line comment must be merged
    // into the preceding non-comment line, because the tokens before
    // the /* and after the */ belong to the same logical statement.
    //
    // Example:  ld a, /*       -> line 1: LD A ,  EndOfLine
    //           comment        -> line 2: EndOfLine  (started_in_comment)
    //           */4            -> line 3: 4 EndOfLine (started_in_comment)
    //
    // After merge: line 1: LD A , 4 EndOfLine
    //              line 2: EndOfLine
    //              line 3: EndOfLine

    for (size_t i = 0; i < num_lines; ++i) {
        auto& tokens = sf.lines[i].tokens;
        assert(!tokens.empty() &&
               tokens.back().type == TokenType::EndOfLine);

        size_t j = i + 1;

        // Merge following lines that started inside a multi-line comment
        if (j < num_lines && started_in_comment[j]) {
            // Remove EndOfLine from current line once
            tokens.pop_back();

            while (j < num_lines && started_in_comment[j]) {
                // Append non-EndOfLine tokens from the next line
                auto& next_tokens = sf.lines[j].tokens;
                assert(!next_tokens.empty() &&
                       next_tokens.back().type == TokenType::EndOfLine);

                // Copy everything except the EndOfLine from next line
                tokens.insert(tokens.end(),
                              next_tokens.begin(),
                              next_tokens.end() - 1);

                // Clear next line to just EndOfLine
                Token eol = next_tokens.back();
                next_tokens.clear();
                next_tokens.push_back(eol);

                j++;
            }

            // Re-add EndOfLine
            SourceLoc end_loc;
            if (!tokens.empty()) {
                const Token& last = tokens.back();
                end_loc.file_id = last.loc.file_id;
                end_loc.line = last.loc.line;
                end_loc.column = last.loc.column +
                                 static_cast<uint16_t>(g_strings.to_string(last.text_id).size());
            }
            else {
                end_loc = sf.lines[i].loc;
            }
            tokens.push_back(Token::end_of_line(end_loc));
        }

        // Now check for backslash continuation on the (possibly merged) line
        size_t num_tokens = tokens.size();
        while (num_tokens >= 2 &&
                tokens[num_tokens - 2].type == TokenType::Backslash &&
                j < num_lines) {
            // Line ends with a backslash token: continuation line.
            tokens.pop_back();   // remove EndOfLine
            tokens.pop_back();   // remove Backslash

            // copy tokens from next line
            auto& next_tokens = sf.lines[j].tokens;
            assert(!next_tokens.empty() &&
                   next_tokens.back().type == TokenType::EndOfLine);
            tokens.insert(tokens.end(),
                          next_tokens.begin(),
                          next_tokens.end());

            // clear next line tokens except for EndOfLine
            next_tokens.erase(next_tokens.begin(),
                              next_tokens.end() - 1);

            num_tokens = tokens.size();
            j++;
        }

        i = j - 1;   // skip merged lines
    }
}

std::vector<Token> tokenize_text(std::string_view text,
                                 const SourceLoc& loc) {
    TokenizeState state;   // fresh state: no multiline comments, etc.
    return tokenize_line(state, text, loc);
}
