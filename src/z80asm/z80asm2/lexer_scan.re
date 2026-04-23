//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "diag.h"
#include "lexer.h"
#include "lexer_scan.h"
#include "options.h"
#include "source_loc.h"
#include <charconv>
#include <string>
#include <vector>

static inline int digit_value(char c) {
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'a' && c <= 'z') {
        return 10 + (c - 'a');
    }
    if (c >= 'A' && c <= 'Z') {
        return 10 + (c - 'A');
    }
    return -1;
}

// Returns true on success, false on error.
// Advances idx and writes the decoded character into out_char.
static bool parse_escape(size_t& idx,
                         bool probing,
                         const ScanLine& line,
                         char& out_char) {
    size_t n = line.text.size();
    if (idx + 1 >= n) {
        if (!probing) {
            g_diag.error(line.locmap[idx], "Unterminated escape sequence");
        }
        return false;
    }

    char esc = line.text[idx + 1];
    idx += 2; // consume '\' and the next char

    switch (esc) {
    case 'n':
        out_char = '\n';
        return true;
    case 't':
        out_char = '\t';
        return true;
    case 'r':
        out_char = '\r';
        return true;
    case 'v':
        out_char = '\v';
        return true;
    case 'f':
        out_char = '\f';
        return true;
    case 'e':
        out_char = '\x1b';
        return true;
    case '\\':
        out_char = '\\';
        return true;
    case '"':
        out_char = '"';
        return true;
    case '\'':
        out_char = '\'';
        return true;

    // Octal: \123
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7': {
        int value = digit_value(esc);
        for (int i = 0; i < 2 && idx < n; i++) {
            int digit = digit_value(line.text[idx]);
            if (digit >= 0 && digit < 8) {
                value = value * 8 + digit;
                idx++;
            }
            else {
                break;
            }
        }
        out_char = static_cast<char>(static_cast<unsigned char>(value & 0xFF));
        return true;
    }

    // Hex: \xFF
    case 'x': {
        if (idx >= n || !is_hex_digit(line.text[idx])) {
            if (!probing) {
                g_diag.error(line.locmap[idx - 2], "Invalid hex escape");
            }
            return false;
        }
        int value = 0;
        int digits = 0;
        while (idx < n && digits < 2 && is_hex_digit(line.text[idx])) {
            value = value * 16 + digit_value(line.text[idx]);
            digits++;
            idx++;
        }
        out_char = static_cast<char>(static_cast<unsigned char>(value & 0xFF));
        return true;
    }

    default:
        if (!probing) {
            g_diag.error(line.locmap[idx - 2], std::string("Unknown escape: \\") + esc);
        }
        return false;
    }
}

static bool scan_quoted_content(char end_quote,
                                bool allow_escapes,
                                bool probing,
                                size_t& idx,
                                const ScanLine& line,
                                std::string& out_content) {
    size_t n = line.text.size();
    idx++; // skip opening quote

    while (idx < n) {
        char c = line.text[idx];

        if (c == end_quote) {
            idx++; // consume closing quote
            return true;
        }

        if (c == '\\' && allow_escapes) {
            char decoded;
            if (!parse_escape(idx, probing, line, decoded)) {
                return false;
            }
            out_content.push_back(decoded);
            continue;
        }

        out_content.push_back(c);
        idx++;
    }

    if (!probing) {
        g_diag.error(line.locmap[idx], "Unterminated string literal");
    }
    idx = n;    // advance past the malformed string
    return false;
}

static void parse_string(char end_quote,
                         size_t& idx,
                         const ScanLine& line,
                         std::vector<Token>& out) {
    size_t start = idx;
    std::string content;

    if (!scan_quoted_content(end_quote,
                             /*allow_escapes=*/true,
                             /*probing=*/false,
                             idx, line, content)) {
        return;
    }

    out.push_back(Token::string(line.text.substr(start, idx - start),
                                content,
                                line.locmap[start]));
}

static void parse_char_literal(size_t& idx,
                               const ScanLine& line,
                               std::vector<Token>& out) {
    size_t start = idx;      // points at opening '
    size_t probe = idx;      // speculative index

    std::string content;

    // Try to parse as a quoted literal
    bool ok = scan_quoted_content('\'',
                                  /*allow_escapes=*/true,
                                  /*probing=*/true,
                                  probe,
                                  line,
                                  content);

    // valid character literal if scan succeeded and consumed
    // exactly one character
    if (ok && content.size() == 1) {
        idx = probe; // commit
        out.push_back(Token::integer(line.text.substr(start, idx - start),
                                     static_cast<int>(content[0]),
                                     line.locmap[start]));
        return;
    }

    // Else this is a Tick token.
    out.push_back(Token::token(TokenType::Tick, "'", line.locmap[start]));
    idx++; // consume '
    return;
}

static void parse_raw_string(char end_quote,
                             size_t& idx,
                             const ScanLine& line,
                             std::vector<Token>& out) {
    size_t start = idx;
    std::string content;

    if (!scan_quoted_content(end_quote,
                             /*allow_escapes=*/false,
                             /*probing=*/false,
                             idx, line, content)) {
        return;
    }

    out.push_back(Token::string(line.text.substr(start, idx - start),
                                content,
                                line.locmap[start]));
}

static double parse_float_from_chars(std::string_view s) {
    std::string t;
    t.reserve(s.size());
    for (char c : s) {
        if (c != '_') {
            t.push_back(c);
        }
    }
    return std::stod(t);
}

static int parse_int_from_chars(std::string_view s, int base) {
    // Remove underscores
    std::string t;
    t.reserve(s.size());
    for (char c : s) {
        if (c != '_') {
            t.push_back(c);
        }
    }

    int value = 0;
    std::from_chars(t.data(), t.data() + t.size(), value, base);
    return value;
}

void tokenize_scan_line(const ScanLine& line,
                        TokenizeState& state,
                        std::vector<Token>& out) {
    bool raw_strings = false;  // whether to treat string literals as raw (no escapes)

    const char* p = line.text.c_str();
    const char* limit = p + line.text.size();
    size_t idx = 0, start = 0;
    size_t end = line.text.size();
    auto current_loc = [&]() -> SourceLoc {
        return line.locmap[idx];
    };

    auto check_trailing_char = [&]() -> bool {
        if (is_ident_char(*p)) {
            std::string literal_text =
            line.text.substr(start, p - line.text.c_str() - start);
            SourceLoc here_loc = current_loc();
            here_loc.column = static_cast<uint16_t>(p - line.text.c_str() + 1);
            g_diag.error(here_loc,
                         "Invalid character '" + std::string(1, *p) +
                         "' after literal: '" + literal_text + "'");
            return false;
        }
        return true;
    };

    auto emit = [&](TokenType type) {
        std::string token_text = line.text.substr(start, p - line.text.c_str() - start);
        out.push_back(Token::token(type, token_text, current_loc()));
    };

    for (; idx < end; idx = static_cast<size_t>(p - line.text.c_str())) {
        // ------------------------------------------------------------
        // 1. If we are inside a multi-line comment, skip until "*/"
        // ------------------------------------------------------------
        if (state.in_multiline_comment) {
            while (idx + 1 < end) {
                if (line.text[idx] == '*' && line.text[idx + 1] == '/') {
                    idx += 2;
                    state.in_multiline_comment = false;
                    state.multiline_comment_start = SourceLoc();
                    goto continue_lexing;
                }
                idx++;
            }
            // Reached end of line still inside comment
            return;
        }

        // ------------------------------------------------------------
        // 2. Check for start of multi-line comment BEFORE re2c runs
        // ------------------------------------------------------------
        if (idx + 1 < end &&
                line.text[idx] == '/' &&
                line.text[idx + 1] == '*') {
            state.in_multiline_comment = true;
            state.multiline_comment_start = current_loc();
            idx += 2;
            continue;
        }

continue_lexing:
        // ------------------------------------------------------------
        // 3. Now run re2c on the remaining text
        // ------------------------------------------------------------
        start = idx;
        p = line.text.c_str() + idx;
        const char* tok = p;
        const char* marker = nullptr;

        /*!re2c
            re2c:define:YYCTYPE = char;
            re2c:define:YYCURSOR = p;
            re2c:define:YYMARKER = marker;
            re2c:define:YYLIMIT = limit;
            re2c:eof = 0;
            re2c:yyfill:enable = 0;
            re2c:indent:top = 2;

            ws          = [ \t\v\f\r\n];
            ident       = [_a-zA-Z][_a-zA-Z0-9]*;
            bin         = [0-1];
            oct         = [0-7];
            dec         = [0-9];
            hex         = [0-9a-fA-F];
            decu        = dec ('_'* dec)*;
            hexu        = hex ('_'* hex)*;
            binu        = bin ('_'* bin)*;
            mantissau   = decu '.' decu* | decu* '.' decu+;
            expu        = [eE] [-+]? decu;

            *       { g_diag.error(current_loc(), "Unexpected character: '" +
                                            std::string(tok, p) + "'");
                      return; }

            ws+     { continue; }
            $       { return; }
            ';'     { return; }
            '//'    { return; }

            '"'     { if (raw_strings) {
                        parse_raw_string('"', idx, line, out);
                      }
                      else {
                        parse_string('"', idx, line, out);
                      }
                      p = line.text.c_str() + idx;
                      continue; }
            "'"     { parse_char_literal(idx, line, out);
                      p = line.text.c_str() + idx;
                      continue; }
            '<'     { if (raw_strings) {
                        parse_raw_string('>', idx, line, out);
                        p = line.text.c_str() + idx;
                        continue;
                      }
                      else {
                        emit(TokenType::LT); continue;
                      }
                    }

            '!'     { emit(TokenType::LogicalNot); continue; }
            '!=' | '<>' {
                      emit(TokenType::NE); continue; }
            '#'     { emit(TokenType::Hash); continue; }
            '##'    { emit(TokenType::DoubleHash); continue; }
            '$'     { emit(TokenType::Dollar); continue; }
            '%'     { emit(TokenType::Modulo); continue; }
            '&'     { emit(TokenType::BitwiseAnd); continue; }
            '&&'    { emit(TokenType::LogicalAnd); continue; }
            '('     { emit(TokenType::LeftParen); continue; }
            ')'     { emit(TokenType::RightParen); continue; }
            '*'     { emit(TokenType::Multiply); continue; }
            '**'    { emit(TokenType::Power); continue; }
            '+'     { emit(TokenType::Plus); continue; }
            ','     { emit(TokenType::Comma); continue; }
            '-'     { emit(TokenType::Minus); continue; }
            '.'     { emit(TokenType::Dot); continue; }
            '/'     { emit(TokenType::Divide); continue; }
            ':'     { emit(TokenType::Colon); continue; }
            '<='    { emit(TokenType::LE); continue; }
            '<<'    { emit(TokenType::LeftShift); continue; }
            '='  | '==' {
                      emit(TokenType::EQ); continue; }
            '>'     { emit(TokenType::GT); continue; }
            '>='    { emit(TokenType::GE); continue; }
            '>>'    { emit(TokenType::RightShift); continue; }
            '?'     { emit(TokenType::Question); continue; }
            '@'     { emit(TokenType::At); continue; }
            '['     { emit(TokenType::LeftBracket); continue; }
            '\\'    { emit(TokenType::Backslash); continue; }
            ']'     { emit(TokenType::RightBracket); continue; }
            '^'     { emit(TokenType::BitwiseXor); continue; }
            '^^'    { emit(TokenType::LogicalXor); continue; }
            '{'     { emit(TokenType::LeftBrace); continue; }
            '|'     { emit(TokenType::BitwiseOr); continue; }
            '||'    { emit(TokenType::LogicalOr); continue; }
            '}'     { emit(TokenType::RightBrace); continue; }
            '~'     { emit(TokenType::BitwiseNot); continue; }

        mantissau expu? {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok, p);
            double value = parse_float_from_chars(digits);
            out.push_back(Token::floating(digits, value, current_loc()));
            continue;
        }

        decu 'd'? {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok, p);
            if (digits.back() == 'd' || digits.back() == 'D') {
                digits.pop_back();
            }
            int value = parse_int_from_chars(digits.c_str(), 10);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        decu ('_'* hex)* 'h' {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok, p - 1);
            int value = parse_int_from_chars(digits.c_str(), 16);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        "$" hexu {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok + 1, p);
            int value = parse_int_from_chars(digits.c_str(), 16);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        '0x' hexu {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok + 2, p);
            int value = parse_int_from_chars(digits.c_str(), 16);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        binu 'b' {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok, p - 1);
            int value = parse_int_from_chars(digits.c_str(), 2);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        [%@] binu {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok + 1, p);
            int value = parse_int_from_chars(digits.c_str(), 2);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        '0b' binu {
            if (!check_trailing_char()) return;
            std::string digits = std::string(tok + 2, p);
            int value = parse_int_from_chars(digits.c_str(), 2);
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        [%@] '"' [-#]* '"' {
            int value = 0;
            for (const char* i = tok + 2; i < p - 1; ++i) {
                value *= 2;
                if (*i == '#') ++value;
            }
            out.push_back(Token::integer(std::string(tok, p), value, current_loc()));
            continue;
        }

        ident {
            std::string ident = std::string(tok, p);
            Keyword keyword = keyword_lookup(ident);

            // check for -ucase
            if (g_args.options.ucase_symbols) {
                ident = to_upper(ident);
            }

            // check for -IXIY
            if (g_args.options.swap_ix_iy) {
                swap_ix_iy(ident, keyword);
            }

            // check for ASMPC
            if (keyword == Keyword::ASMPC) {
                out.push_back(Token::token(TokenType::ASMPC, ident, current_loc()));
                continue;
            }

            // need raw strings after INCLUDE, BINARY, INCBIN, LINE, C_LINE
            if (keyword_directive_has_file_arg(keyword)) {
                raw_strings = true;
            }

            out.push_back(Token::identifier(ident, current_loc()));
            continue;
        }
        */
    }
}
