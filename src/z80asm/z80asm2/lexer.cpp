//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "keywords.h"
#include "lexer.h"
#include "options.h"
#include "source.h"
#include "utils.h"
#include <cstring>
#include <limits>
#include <string>

struct TokenizeState {
    bool in_multiline_comment = false;
    SourceLoc multiline_comment_start;
};

Token Token::token(TokenType type_, const std::string& text_,
                   const SourceLoc& loc) {
    Token t;
    t.type = type_;
    t.text = strpool(text_);
    t.loc = loc;
    return t;
}

Token Token::identifier(const std::string& text_,
                        const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Identifier;
    t.keyword = keyword_lookup(text_);
    t.text = strpool(text_);
    t.loc = loc;
    return t;
}

Token Token::integer(const std::string& text_, int value,
                     const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Integer;
    t.text = strpool(text_);
    t.int_value = value;
    t.loc = loc;
    return t;
}

Token Token::floating(const std::string& text_, double value,
                      const SourceLoc& loc) {
    Token t;
    t.type = TokenType::Float;
    t.text = strpool(text_);
    t.float_value = value;
    t.loc = loc;
    return t;
}

Token Token::string(const std::string& text_, const std::string& value,
                    const SourceLoc& loc) {
    Token t;
    t.type = TokenType::String;
    t.text = strpool(text_);
    t.str_value = strpool(value);
    t.loc = loc;
    return t;
}

Token Token::end_of_line(const SourceLoc& loc) {
    Token t;
    t.type = TokenType::EndOfLine;
    t.loc = loc;
    return t;
}

Token Token::end_of_file(const SourceLoc& loc) {
    Token t;
    t.type = TokenType::EndOfFile;
    t.loc = loc;
    return t;
}

static int hex_to_int(char c) {
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'a' && c <= 'f') {
        return 10 + (c - 'a');
    }
    if (c >= 'A' && c <= 'F') {
        return 10 + (c - 'A');
    }
    return 0;
}

static std::string unescape_string_literal(const std::string& s) {
    std::string out;
    out.reserve(s.size());

    for (size_t i = 0; i < s.size(); i++) {
        if (s[i] != '\\' || i + 1 >= s.size()) {
            out.push_back(s[i]);
            continue;
        }

        char e = s[++i];
        switch (e) {
        case 'n':
            out.push_back('\n');
            break;
        case 'r':
            out.push_back('\r');
            break;
        case 't':
            out.push_back('\t');
            break;
        case 'a':
            out.push_back('\a');
            break;
        case 'b':
            out.push_back('\b');
            break;
        case 'f':
            out.push_back('\f');
            break;
        case 'v':
            out.push_back('\v');
            break;
        case 'e':
            out.push_back('\x1b');
            break; // escape character
        case '\\':
            out.push_back('\\');
            break;
        case '"':
            out.push_back('"');
            break;
        case '\'':
            out.push_back('\'');
            break;

        case 'x': {
            int value = 0;
            int digits = 0;
            while (i + 1 < s.size() && digits < 2 && is_hex_digit(s[i + 1])) {
                i++;
                value = (value << 4) | hex_to_int(s[i]);
                digits++;
            }
            if (digits > 0) {
                out.push_back(static_cast<char>(value & 0xFF));
            }
            else {
                out.push_back('\\');
                out.push_back('x');
            }
            break;
        }

        default:
            // octal escape: \[0-7]{1,3}
            if (is_oct_digit(e)) {
                int value = e - '0';
                int digits = 1;

                while (i + 1 < s.size() && digits < 3 && is_oct_digit(s[i + 1])) {
                    i++;
                    value = (value << 3) | (s[i] - '0');
                    digits++;
                }

                out.push_back(static_cast<char>(value & 0xFF));
            }
            else {
                // preserve unknown escapes verbatim
                out.push_back('\\');
                out.push_back(e);
            }
            break;
        }
    }

    return out;
}

static bool parse_ident1(const char* text, size_t length, size_t& pos, std::string& out) {
    if (pos >= length || !is_ident_start(text[pos])) {
        return false;
    }

    size_t start = pos;
    pos++;
    while (pos < length && is_ident_char(text[pos])) {
        pos++;
    }

    out.assign(text + start, pos - start);
    return true;
}

// replace IX<->IY, IXH<->IYH, AIX<->AIY, XIX<->YIY
static void swap_x_y(std::string& str) {
    for (auto& c : str) {
        switch (c) {
        case 'x':
            c = 'y';
            break;
        case 'X':
            c = 'Y';
            break;
        case 'y':
            c = 'x';
            break;
        case 'Y':
            c = 'X';
            break;
        default:
            ;
        }
    }
}

static void swap_ix_iy(std::string& str, Keyword& keyword) {
    if (keyword_is_x_register(keyword)) {
        swap_x_y(str);
        keyword = keyword_lookup(str);
    }
}

static bool keyword_to_plus_register_token(Keyword kw, TokenType& token_type) {
    switch (kw) {
    case Keyword::A:
        token_type = TokenType::PlusA;
        return true;
    case Keyword::BC:
        token_type = TokenType::PlusBC;
        return true;
    case Keyword::DE:
        token_type = TokenType::PlusDE;
        return true;
    case Keyword::HL:
        token_type = TokenType::PlusHL;
        return true;
    case Keyword::IX:
        token_type = TokenType::PlusIX;
        return true;
    case Keyword::IY:
        token_type = TokenType::PlusIY;
        return true;
    default:
        return false;
    }
}

static bool scan_decu(const char* text, size_t length, size_t& pos) {
    if (pos >= length || !is_digit(text[pos])) {
        return false;
    }

    pos++;
    while (pos < length) {
        size_t save = pos;
        while (pos < length && text[pos] == '_') {
            pos++;
        }

        if (pos < length && is_digit(text[pos])) {
            pos++;
        }
        else {
            pos = save;
            break;
        }
    }

    return true;
}

static bool scan_hexu(const char* text, size_t length, size_t& pos) {
    if (pos >= length || !is_hex_digit(text[pos])) {
        return false;
    }

    pos++;
    while (pos < length) {
        size_t save = pos;
        while (pos < length && text[pos] == '_') {
            pos++;
        }

        if (pos < length && is_hex_digit(text[pos])) {
            pos++;
        }
        else {
            pos = save;
            break;
        }
    }

    return true;
}

static bool scan_binu(const char* text, size_t length, size_t& pos) {
    if (pos >= length || !is_bin_digit(text[pos])) {
        return false;
    }

    pos++;
    while (pos < length) {
        size_t save = pos;
        while (pos < length && text[pos] == '_') {
            pos++;
        }

        if (pos < length && is_bin_digit(text[pos])) {
            pos++;
        }
        else {
            pos = save;
            break;
        }
    }

    return true;
}

static bool parse_int_literal(const std::string& text, int base, int& value) {
    std::string clean;
    clean.reserve(text.size());

    for (char c : text) {
        if (c != '_') {
            clean.push_back(c);
        }
    }

    try {
        size_t idx = 0;
        long long parsed = std::stoll(clean, &idx, base);
        if (idx != clean.size()) {
            return false;
        }
        if (parsed < std::numeric_limits<int>::min() ||
            parsed > std::numeric_limits<int>::max()) {
            return false;
        }

        value = static_cast<int>(parsed);
        return true;
    }
    catch (...) {
        return false;
    }
}

enum class ScanResult {
    NoMatch,
    Matched,
    Error,
};

static ScanResult try_scan_integer_literal(SourceLine& line,
                                           const char* text,
                                           size_t length,
                                           size_t& pos,
                                           const SourceLoc& loc) {
    struct Candidate {
        bool matched = false;
        size_t end = 0;
        int base = 10;
        std::string digits;
        std::string kind;
    };

    Candidate best;

    auto consider = [&](size_t end, int base, const std::string& digits, const std::string& kind) {
        if (!best.matched || end > best.end) {
            best.matched = true;
            best.end = end;
            best.base = base;
            best.digits = digits;
            best.kind = kind;
        }
    };

    // $hexu
    if (text[pos] == '$') {
        size_t p = pos + 1;
        if (scan_hexu(text, length, p)) {
            consider(p, 16, std::string(text + pos + 1, p - pos - 1), "hexadecimal");
        }
    }

    // [%@] binu
    if (text[pos] == '%' || text[pos] == '@') {
        size_t p = pos + 1;
        if (scan_binu(text, length, p)) {
            consider(p, 2, std::string(text + pos + 1, p - pos - 1), "binary");
        }
    }

    // 0x hexu / 0X hexu
    if (text[pos] == '0' && pos + 1 < length &&
        (text[pos + 1] == 'x' || text[pos + 1] == 'X')) {
        size_t p = pos + 2;
        if (scan_hexu(text, length, p)) {
            consider(p, 16, std::string(text + pos + 2, p - pos - 2), "hexadecimal");
        }
    }

    // 0b binu / 0B binu
    if (text[pos] == '0' && pos + 1 < length &&
        (text[pos + 1] == 'b' || text[pos + 1] == 'B')) {
        size_t p = pos + 2;
        if (scan_binu(text, length, p)) {
            consider(p, 2, std::string(text + pos + 2, p - pos - 2), "binary");
        }
    }

    // decu, decu d?, binu b, decu ('_'* hex)* h
    size_t p = pos;
    if (scan_decu(text, length, p)) {
        // decu
        consider(p, 10, std::string(text + pos, p - pos), "decimal");

        // decu 'd'?
        if (p < length && (text[p] == 'd' || text[p] == 'D')) {
            consider(p + 1, 10, std::string(text + pos, p - pos), "decimal");
        }

        // binu 'b'
        size_t pb = pos;
        if (scan_binu(text, length, pb) &&
            pb < length && (text[pb] == 'b' || text[pb] == 'B')) {
            consider(pb + 1, 2, std::string(text + pos, pb - pos), "binary");
        }

        // decu ('_'* hex)* 'h'
        size_t ph = p;
        while (ph < length) {
            size_t save = ph;
            while (ph < length && text[ph] == '_') {
                ph++;
            }

            if (ph < length && is_hex_digit(text[ph])) {
                ph++;
            }
            else {
                ph = save;
                break;
            }
        }

        if (ph < length && (text[ph] == 'h' || text[ph] == 'H')) {
            consider(ph + 1, 16, std::string(text + pos, ph - pos), "hexadecimal");
        }
    }

    if (!best.matched) {
        return ScanResult::NoMatch;
    }

    std::string token_text(text + pos, best.end - pos);
    if (best.end < length && is_ident_char(text[best.end])) {
        error(loc,
              "Invalid character '" + std::string(1, text[best.end]) +
              "' after literal: '" + token_text + "'");
        return ScanResult::Error;
    }

    int value = 0;
    if (!parse_int_literal(best.digits, best.base, value)) {
        error(loc, "Invalid " + best.kind + " integer: " + best.digits);
        return ScanResult::Error;
    }

    line.tokens.push_back(Token::integer(token_text, value, loc));
    pos = best.end;
    return ScanResult::Matched;
}

static bool parse_float_literal(const std::string& text, double& value) {
    std::string clean;
    clean.reserve(text.size());

    for (char c : text) {
        if (c != '_') {
            clean.push_back(c);
        }
    }

    try {
        size_t idx = 0;
        value = std::stod(clean, &idx);
        return idx == clean.size();
    }
    catch (...) {
        return false;
    }
}

static void tokenize_line(SourceLine& line, TokenizeState& state) {
    // set to true after INCLUDE et.al. to allow raw string literals in included file names
    bool raw_strings = false;

    const char* text = line.text;
    size_t pos = 0;
    size_t length = std::strlen(text);
    while (pos < length) {
        char c = text[pos];

        // end of multi-line comment
        if (state.in_multiline_comment) {
            const char* end = std::strstr(text + pos, "*/");
            if (end != nullptr) {
                // leave pos after '/'
                pos = static_cast<size_t>(end - text) + 2;
                state.in_multiline_comment = false;
                state.multiline_comment_start = SourceLoc();
            }
            else {
                // not found in this line
                pos = length;
            }
            continue;
        }

        // skip whitespace
        if (is_space(c)) {
            pos++;
            continue;
        }

        // skip assembly comments
        if (c == ';') {
            break;
        }

        // define loc for the following token
        SourceLoc loc = line.loc;
        loc.column = static_cast<int>(pos) + 1;

        // skip multi-line comments and single-line C++ comments
        if (c == '/' && pos + 1 < length) {
            char next = text[pos + 1];
            if (next == '/') {
                // single-line comment, skip rest of line
                break;
            }
            else if (next == '*') {
                // start of multi-line comment
                state.in_multiline_comment = true;
                state.multiline_comment_start = loc;
                pos += 2;
                continue;
            }
        }

        // scan bitmaps: [%@] "[-#]*"
        if ((c == '%' || c == '@') && pos + 1 < length && text[pos + 1] == '"') {
            size_t start = pos;
            pos += 2; // skip prefix and opening quote

            int value = 0;
            while (pos < length && text[pos] != '"') {
                if (text[pos] != '-' && text[pos] != '#') {
                    error(loc, std::string("Invalid character in bitmap literal: '") + text[pos] + "'");
                    break;
                }

                value *= 2;
                if (text[pos] == '#') {
                    value++;
                }
                pos++;
            }

            if (pos >= length || text[pos] != '"') {
                error(loc, "Unterminated bitmap literal");
                break;
            }

            std::string token_text(text + start, pos - start + 1);
            line.tokens.push_back(Token::integer(token_text, value, loc));
            pos++; // skip closing quote
            continue;
        }

        // scan prefix integers before identifier/token handling
        if (c == '$' || c == '%' || c == '@') {
            ScanResult result = try_scan_integer_literal(line, text, length, pos, loc);
            if (result == ScanResult::Matched) {
                continue;
            }
            if (result == ScanResult::Error) {
                break;
            }
        }

        // scan identifiers and keywords, allowing optional '@' prefix and infix (e.g. @foo, foo@bar)
        if (c == '@' || is_ident_start(c)) {
            std::string ident;

            if (c == '@') {
                // ident = '@' ident1
                pos++; // consume '@'
                std::string rhs;
                size_t rhs_pos = pos;
                if (parse_ident1(text, length, rhs_pos, rhs)) {
                    ident = "@" + rhs;
                    pos = rhs_pos;
                }
                else {
                    // standalone '@' is not an identifier
                    line.tokens.push_back(Token::token(TokenType::At, "@", loc));
                    continue;
                }
            }
            else {
                // ident starts as ident1
                std::string lhs;
                parse_ident1(text, length, pos, lhs); // guaranteed by condition
                ident = lhs;

                // optional: ident1 '@' ident1
                if (pos < length && text[pos] == '@') {
                    size_t rhs_pos = pos + 1;
                    std::string rhs;
                    if (parse_ident1(text, length, rhs_pos, rhs)) {
                        ident += "@";
                        ident += rhs;
                        pos = rhs_pos;
                    }
                }
            }

            // convert to uppercase if the option is enabled
            if (g_options.ucase_labels) {
                ident = to_upper(ident);
            }

            // get keyword
            Keyword keyword = keyword_lookup(ident);

            // handle AF' et.al.
            if (pos < length && text[pos] == '\'' && keyword_lookup(ident + "'") != Keyword::None) {
                ident += "'";
                keyword = keyword_lookup(ident);
                pos++;
            }

            // check for IX/IY register swapping
            if (keyword_is_x_register(keyword) && g_options.swap_ix_iy) {
                swap_ix_iy(ident, keyword);
            }

            // check for .ASSUME
            if (keyword == Keyword::ASSUME &&
                !line.tokens.empty() && line.tokens.back().type == TokenType::Dot) {
                line.tokens.pop_back();       // remove '.'
            }

            // check for ASMPC
            if (keyword == Keyword::ASMPC) {
                line.tokens.push_back(Token::token(TokenType::ASMPC, ident, loc));
                continue;
            }

            // check for keywords that need raw string arguments (e.g. INCLUDE)
            // to allow raw string literals in included file names
            if (keyword_directive_has_file_arg(keyword)) {
                raw_strings = true;
            }

            line.tokens.push_back(Token::identifier(ident, loc));
            continue;
        }

        // scan floating-point numbers:
        // mantissau = decu '.' decu* | decu* '.' decu+
        // expu      = [eE] [-+]? decu
        if (is_digit(c) || (c == '.' && pos + 1 < length && is_digit(text[pos + 1]))) {
            size_t p = pos;

            bool has_left = scan_decu(text, length, p);
            if (p < length && text[p] == '.') {
                p++;
                bool has_right = scan_decu(text, length, p);

                if (has_left || has_right) {
                    size_t exp_end = p;
                    if (exp_end < length && (text[exp_end] == 'e' || text[exp_end] == 'E')) {
                        size_t pexp = exp_end + 1;
                        if (pexp < length && (text[pexp] == '+' || text[pexp] == '-')) {
                            pexp++;
                        }

                        if (scan_decu(text, length, pexp)) {
                            exp_end = pexp;
                        }
                    }

                    p = exp_end;

                    if (p < length && is_ident_char(text[p])) {
                        error(loc,
                              "Invalid character '" + std::string(1, text[p]) +
                              "' after literal: '" + std::string(text + pos, p - pos) + "'");
                        break;
                    }

                    std::string num_str(text + pos, p - pos);
                    double value = 0.0;
                    if (!parse_float_literal(num_str, value)) {
                        error(loc, "Invalid float: " + num_str);
                        break;
                    }

                    line.tokens.push_back(Token::floating(num_str, value, loc));
                    pos = p;
                    continue;
                }
            }
        }

        // scan integers
        if (is_digit(c)) {
            ScanResult result = try_scan_integer_literal(line, text, length, pos, loc);
            if (result == ScanResult::Matched) {
                continue;
            }
            if (result == ScanResult::Error) {
                break;
            }
        }

        // scan string literals
        if (c == '"') {
            size_t start = pos;
            pos++; // skip opening quote
            while (pos < length) {
                if (!raw_strings && text[pos] == '\\' && pos + 1 < length) {
                    pos += 2; // skip escaped character
                }
                else if (text[pos] == '"') {
                    break; // end of string
                }
                else {
                    pos++;
                }
            }

            if (pos >= length || text[pos] != '"') {
                error(loc, "Unterminated string literal");
                break;
            }

            std::string str_raw(text + start + 1, pos - start - 1); // without quotes
            std::string str_value = raw_strings ? str_raw : unescape_string_literal(str_raw);
            std::string token_text(text + start, pos - start + 1);   // with quotes
            line.tokens.push_back(Token::string(token_text, str_value, loc));
            pos++; // skip closing quote
            continue;
        }

        // scan file literals in angle brackets, only in raw string context (e.g. INCLUDE)
        if (raw_strings && c == '<') {
            size_t start = pos;
            pos++; // skip opening '<'
            while (pos < length && text[pos] != '>') {
                pos++;
            }

            if (pos >= length || text[pos] != '>') {
                error(loc, "Unterminated angle-bracket file literal");
                break;
            }

            std::string file_value(text + start + 1, pos - start - 1); // without brackets
            std::string token_text(text + start, pos - start + 1);      // with brackets
            line.tokens.push_back(Token::string(token_text, file_value, loc));
            pos++; // skip closing '>'
            continue;
        }

        // scan character literal
        if (c == '\'') {
            size_t start = pos;
            pos++; // skip opening quote
            while (pos < length) {
                if (text[pos] == '\\' && pos + 1 < length) {
                    pos += 2; // skip escaped character
                }
                else if (text[pos] == '\'') {
                    break; // end of character literal
                }
                else {
                    pos++;
                }
            }

            if (pos >= length || text[pos] != '\'') {
                error(loc, "Unterminated character literal");
                break;
            }

            std::string char_text(text + start + 1, pos - start - 1); // exclude quotes
            std::string char_value = unescape_string_literal(char_text);

            if (char_value.size() != 1) {
                error(loc, "Character literal must contain exactly one character");
            }
            else {
                int value = static_cast<unsigned char>(char_value[0]);
                std::string token_text(text + start, pos - start + 1); // include quotes
                line.tokens.push_back(Token::integer(token_text, value, loc));
            }

            pos++; // skip closing quote
            continue;
        }

        // scan '+' and disambiguate +register from +expression
        if (c == '+') {
            size_t plus_pos = pos;
            size_t p = pos + 1;

            while (p < length && is_space(text[p])) {
                p++;
            }

            std::string reg_str;
            size_t p_ident_end = p;
            if (parse_ident1(text, length, p_ident_end, reg_str)) {
                Keyword reg_kw = keyword_lookup(reg_str);

                TokenType plus_reg_type;
                if (keyword_to_plus_register_token(reg_kw, plus_reg_type)) {
                    // token text contains only '+' and identifier (no whitespace)
                    line.tokens.push_back(Token::token(plus_reg_type, "+" + reg_str, loc));
                    pos = p_ident_end;
                    continue;
                }
            }

            // not a +register, keep only Plus and rewind to char after '+'
            line.tokens.push_back(Token::token(TokenType::Plus, "+", loc));
            pos = plus_pos + 1;
            continue;
        }

        // scan two-character operators/delimiters
        if (pos + 1 < length) {
            char c2 = text[pos + 1];

            switch (c) {
            case '!':
                if (c2 == '=') {
                    line.tokens.push_back(Token::token(TokenType::NE, "!=", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '#':
                if (c2 == '#') {
                    line.tokens.push_back(Token::token(TokenType::DoubleHash, "##", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '&':
                if (c2 == '&') {
                    line.tokens.push_back(Token::token(TokenType::LogicalAnd, "&&", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '*':
                if (c2 == '*') {
                    line.tokens.push_back(Token::token(TokenType::Power, "**", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '<':
                if (c2 == '<') {
                    line.tokens.push_back(Token::token(TokenType::LeftShift, "<<", loc));
                    pos += 2;
                    continue;
                }
                if (c2 == '=') {
                    line.tokens.push_back(Token::token(TokenType::LE, "<=", loc));
                    pos += 2;
                    continue;
                }
                if (c2 == '>') {
                    line.tokens.push_back(Token::token(TokenType::NE, "<>", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '=':
                if (c2 == '=') {
                    line.tokens.push_back(Token::token(TokenType::EQ, "=", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '>':
                if (c2 == '=') {
                    line.tokens.push_back(Token::token(TokenType::GE, ">=", loc));
                    pos += 2;
                    continue;
                }
                if (c2 == '>') {
                    line.tokens.push_back(Token::token(TokenType::RightShift, ">>", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '^':
                if (c2 == '^') {
                    line.tokens.push_back(Token::token(TokenType::LogicalXor, "^^", loc));
                    pos += 2;
                    continue;
                }
                break;
            case '|':
                if (c2 == '|') {
                    line.tokens.push_back(Token::token(TokenType::LogicalOr, "||", loc));
                    pos += 2;
                    continue;
                }
                break;
            default:
                break;
            }
        }

        // scan single-character operators/delimiters
        switch (c) {
        case '!':
            line.tokens.push_back(Token::token(TokenType::LogicalNot, "!", loc));
            break;
        case '#':
            line.tokens.push_back(Token::token(TokenType::Hash, "#", loc));
            break;
        case '$':
            line.tokens.push_back(Token::token(TokenType::Dollar, "$", loc));
            break;
        case '%':
            line.tokens.push_back(Token::token(TokenType::Modulo, "%", loc));
            break;
        case '&':
            line.tokens.push_back(Token::token(TokenType::BitwiseAnd, "&", loc));
            break;
        case '*':
            line.tokens.push_back(Token::token(TokenType::Multiply, "*", loc));
            break;
        case '-':
            line.tokens.push_back(Token::token(TokenType::Minus, "-", loc));
            break;
        case '/':
            line.tokens.push_back(Token::token(TokenType::Divide, "/", loc));
            break;
        case ':':
            line.tokens.push_back(Token::token(TokenType::Colon, ":", loc));
            break;
        case '<':
            line.tokens.push_back(Token::token(TokenType::LT, "<", loc));
            break;
        case '=':
            line.tokens.push_back(Token::token(TokenType::EQ, "=", loc));
            break;
        case '>':
            line.tokens.push_back(Token::token(TokenType::GT, ">", loc));
            break;
        case '?':
            line.tokens.push_back(Token::token(TokenType::Question, "?", loc));
            break;
        case '@':
            line.tokens.push_back(Token::token(TokenType::At, "@", loc));
            break;
        case '[':
            line.tokens.push_back(Token::token(TokenType::LeftBracket, "[", loc));
            break;
        case '\\':
            line.tokens.push_back(Token::token(TokenType::Backslash, "\\", loc));
            break;
        case ']':
            line.tokens.push_back(Token::token(TokenType::RightBracket, "]", loc));
            break;
        case '^':
            line.tokens.push_back(Token::token(TokenType::BitwiseXor, "^", loc));
            break;
        case '{':
            line.tokens.push_back(Token::token(TokenType::LeftBrace, "{", loc));
            break;
        case '|':
            line.tokens.push_back(Token::token(TokenType::BitwiseOr, "|", loc));
            break;
        case '}':
            line.tokens.push_back(Token::token(TokenType::RightBrace, "}", loc));
            break;
        case '~':
            line.tokens.push_back(Token::token(TokenType::BitwiseNot, "~", loc));
            break;
        default:
            error(loc, std::string("Unexpected character: '") + c + "'");
        }
        pos++;
    }
}

static bool strip_line_continuation(SourceLine& line) {
    const char* text = line.text;
    size_t length = std::strlen(text);
    if (length > 0 && text[length - 1] == '\\') {
        line.text = strpool(std::string(text, length - 1));
        return true;
    }
    return false;
}

void tokenize(SourceFile& source) {
    TokenizeState state;

    for (size_t i = 0; i < source.lines.size(); i++) {
        SourceLine& start_line = source.lines[i];
        SourceLine* target_line = &start_line;
        SourceLine* current_line = &start_line;

        while (true) {
            bool has_continuation = strip_line_continuation(*current_line);
            tokenize_line(*current_line, state);

            if (current_line != target_line) {
                target_line->tokens.insert(target_line->tokens.end(),
                                           current_line->tokens.begin(),
                                           current_line->tokens.end());
                current_line->tokens.clear();
            }

            if (has_continuation && (i + 1) < source.lines.size()) {
                i++;
                current_line = &source.lines[i];
                continue;
            }

            SourceLoc end_loc = current_line->loc;
            end_loc.column = static_cast<int>(std::strlen(current_line->text)) + 1;
            target_line->tokens.push_back(Token::end_of_line(end_loc));
            break;
        }
    }

    if (state.in_multiline_comment) {
        error(state.multiline_comment_start, "Unterminated multi-line comment");
    }
}

std::vector<Token> tokenize_text(const std::string& text, const SourceLoc& loc) {
    SourceFile source;
    source.file = strpool(loc.file);
    source.lines = split_source_lines(loc.file, text);

    // adjust source locations to start at the requested location
    int start_line = loc.line > 0 ? loc.line : 1;
    for (size_t i = 0; i < source.lines.size(); i++) {
        source.lines[i].loc.file = source.file;
        source.lines[i].loc.line = start_line + static_cast<int>(i);
        source.lines[i].loc.column = 1;
    }

    tokenize(source);

    // adjust first-line columns to start at the requested column
    if (!source.lines.empty() && loc.column > 1) {
        for (Token& token : source.lines[0].tokens) {
            token.loc.column += loc.column - 1;
        }
    }

    std::vector<Token> tokens;
    for (const SourceLine& line : source.lines) {
        tokens.insert(tokens.end(), line.tokens.begin(), line.tokens.end());
    }

    return tokens;
}
