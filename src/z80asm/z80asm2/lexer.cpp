//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "lexer_keywords.h"
#include "scan.h"
#include "source.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
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

static bool strip_line_continuation(std::string& line) {
    if (!line.empty() && line.back() == '\\') {
        // result must be the same size so that locmap stays correct,
        // so replace backslash with space
        line.pop_back();
        line.push_back(' ');
        return true;
    }
    return false;
}

static std::string_view get_line_view(const SourceFile& sf,
                                      const std::string_view content,
                                      uint32_t line) {
    uint32_t off = sf.line_offsets[line];
    uint32_t len = sf.line_lengths[line];
    return std::string_view(content.data() + off, len);
}

void tokenize(SourceFile& sf, const std::string_view content) {
    TokenizeState state;
    uint32_t num_lines = static_cast<uint32_t>(sf.line_offsets.size());

    sf.lines_tokens.resize(num_lines);

    for (uint32_t i = 0; i < num_lines; ++i) {
        uint32_t logical_start = i;

        // Build merged logical line
        MergedLine merged;
        merged.file_id = sf.file_id;
        merged.logical_line = logical_start + 1;

        // First physical line
        std::string_view first = get_line_view(sf, content, i);

        merged.text.reserve(first.size());
        merged.locmap.reserve(first.size());

        int col = 1;
        uint32_t physical_line = i + 1;

        for (char c : first) {
            merged.text.push_back(c);
            merged.locmap.emplace_back(sf.file_id, physical_line, col++);
        }

        // Handle continuation lines
        while (strip_line_continuation(merged.text)) {
            if (i + 1 >= num_lines) {
                break;
            }

            ++i;
            std::string_view next = get_line_view(sf, content, i);

            physical_line = i + 1;
            col = 1;

            for (char c : next) {
                merged.text.push_back(c);
                merged.locmap.emplace_back(sf.file_id, physical_line, col++);
            }
        }

        // Tokenize merged line
        std::vector<Token> tokens;
        tokenize_line(merged, state, tokens);

        if (!state.in_multiline_comment) {
            // Compute end-of-line SourceLoc based on last token
            SourceLoc end_loc;
            if (!tokens.empty()) {
                const Token& last = tokens.back();
                end_loc.file_id = last.loc.file_id;
                end_loc.line = last.loc.line;   // physical line
                end_loc.column = last.loc.column +
                                 static_cast<uint16_t>(g_strings.to_string(last.text_id).size());
            }
            else {
                // No tokens: end-of-line is at column 1 of the first physical line
                end_loc = SourceLoc(sf.file_id, logical_start + 1, 1);
            }

            tokens.push_back(Token::end_of_line(end_loc));
        }

        // Store tokens in the first physical line
        sf.lines_tokens[logical_start] = std::move(tokens);
    }

    if (state.in_multiline_comment) {
        error(state.multiline_comment_start,
              "Unterminated multi-line comment");
    }
}

std::vector<Token> tokenize_text(const std::string_view text,
                                 const SourceLoc& loc) {
    // Build a temporary merged line
    MergedLine merged;
    merged.file_id = loc.file_id;
    merged.logical_line = loc.line;   // for listing if needed
    merged.text = text;
    merged.locmap.reserve(text.size());

    int col = loc.column;
    for ([[maybe_unused]] char c : text) {
        merged.locmap.emplace_back(loc.file_id, loc.line, col++);
    }

    // Tokenize
    TokenizeState state;   // fresh state: no multiline comments, etc.
    std::vector<Token> tokens;
    tokenize_line(merged, state, tokens);

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
