//-----------------------------------------------------------------------------
// z80asm
// Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "scanner.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <cstring>
#include <iostream>
#include <limits>
using namespace std;

static inline bool isbindigit(char c) { return c == '0' || c == '1'; }

static inline bool is_token_delimiter(char c) {
    return c == '\0' || isspace((unsigned char)c) || ispunct((unsigned char)c);
}


Scanner::Scanner(const vector<Token>& tokens) {
    m_tokens = tokens;
}

void Scanner::clear() {
    m_tokens.clear();
    m_pos = 0;
}

bool Scanner::scan(const string& text) {
    clear();
    const char* p = text.c_str();

    while (*p != '\0') {
        bool blank_before = false;

        // Skip blanks (but not newlines)
        while (isspace((unsigned char)*p)) {
            if (*p == '\n')
                break;
            blank_before = true;
            ++p;
        }
        if (*p == '\0')
            break;

        const char* p0 = p;
        int val = 0;

        switch (*p++) {
        case '0':
            if (*p == 'x' || *p == 'X') {
                ++p;
                if (!read_number_literal(p, ::isxdigit, 16, val, 0))
                    return false;
                m_tokens.emplace_back(TType::INT, blank_before);
                m_tokens.back().set_ivalue(val);
                break;
            }
            else if (*p == 'b' || *p == 'B') {
                ++p;
                if (!read_number_literal(p, ::isbindigit, 2, val, 0))
                    return false;
                m_tokens.emplace_back(TType::INT, blank_before);
                m_tokens.back().set_ivalue(val);
                break;
            }
            // fallthrough to decimal
            [[fallthrough]];

        case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9': {
            --p;

            // Try hex with suffix h/H
            {
                const char* t = p;
                while (isxdigit((unsigned char)*t) || *t == '_')
                    ++t;
                if (*t == 'h' || *t == 'H') {
                    if (!read_number_literal(p, ::isxdigit, 16, val, 'h'))
                        return false;
                    m_tokens.emplace_back(TType::INT, blank_before);
                    m_tokens.back().set_ivalue(val);
                    continue;
                }
            }

            // Try binary with suffix b/B
            {
                const char* t = p;
                while ((*t == '0' || *t == '1' || *t == '_'))
                    ++t;
                if (*t == 'b' || *t == 'B') {
                    if (!read_number_literal(p, ::isbindigit, 2, val, 'b'))
                        return false;
                    m_tokens.emplace_back(TType::INT, blank_before);
                    m_tokens.back().set_ivalue(val);
                    continue;
                }
            }

            // Try float (C-style)
            {
                double fval{ 0.0 };
                const char* float_probe = p;
                if (looks_like_float(float_probe)) {
                    if (read_float_literal(p, fval)) {
                        m_tokens.emplace_back(TType::FLOAT, blank_before);
                        m_tokens.back().set_fvalue(fval);
                        continue;
                    }
                    else {
                        clear();
                        return false;
                    }
                }
            }

            // Fallback: parse as decimal
            if (!read_number_literal(p, ::isdigit, 10, val, 0))
                return false;

            m_tokens.emplace_back(TType::INT, blank_before);
            m_tokens.back().set_ivalue(val);
            continue;
        }

        case '.': {
            --p;
            double fval{ 0.0 };
            const char* float_probe = p;
            if (looks_like_float(float_probe)) {
                if (read_float_literal(p, fval)) {
                    m_tokens.emplace_back(TType::FLOAT, blank_before);
                    m_tokens.back().set_fvalue(fval);
                    continue;
                }
                else {
                    clear();
                    return false;
                }
            }
            else {
                if (!scan_operator(p, blank_before) &&
                    !scan_symbol(p, blank_before)) {
                    g_error->error_invalid_char(*p0);
                    clear();
                    return false;
                }
            }
            break;
        }

        case '$':
            if (isxdigit((unsigned char)*p)) {
                if (!read_number_literal(p, ::isxdigit, 16, val, 0))
                    return false;
                m_tokens.emplace_back(TType::INT, blank_before);
                m_tokens.back().set_ivalue(val);
            }
            else {
                m_tokens.emplace_back(TType::ASMPC, blank_before);
            }
            break;

        case '%':
        case '@':
            if (isbindigit((unsigned char)*p)) {
                if (!read_number_literal(p, ::isbindigit, 2, val, 0))
                    return false;
                m_tokens.emplace_back(TType::INT, blank_before);
                m_tokens.back().set_ivalue(val);
            }
            else if (*p == '"') {
                // bitmask
                ++p;
                if (!scan_bitmask(p, blank_before))
                    return false;
            }
            else {
                p--;  // rewind to @ or '%'
                if (!scan_operator(p, blank_before) &&
                    !scan_symbol(p, blank_before)) {
                    g_error->error_invalid_char(*p0);
                    clear();
                    return false;
                }
            }
            break;

        case '\n':
            // Handle newline 
            m_tokens.emplace_back(TType::NEWLINE, blank_before);
            break;

        case ';':
            // Handle comment
            skip_comment(p);
            break;

        case '"':
        case '\'':
            --p;
            if (!scan_string_or_char(p, blank_before))
                return false;
            break;

        default:
            --p;
            if (isalpha((unsigned char)*p) || *p == '_') {
                if (!scan_identifier_or_keyword(p, blank_before))
                    return false;
            }
            else if (
                !scan_operator(p, blank_before) &&
                !scan_symbol(p, blank_before)
                ) {
                g_error->error_invalid_char(*p0);
                clear();
                return false;
            }
        }
    }

    return true;
}

bool Scanner::scan_identifier_or_keyword(const char*& p, bool blank_before) {
    const char* p0 = p;

    while (is_ident((unsigned char)*p))
        ++p;

    if (*p == '\'')
        ++p;

    string arg(p0, p);
    Keyword keyword = ::lookup_keyword(arg);

    if (keyword == Keyword::NONE && arg.back() == '\'') {
        --p;
        arg.pop_back();
        keyword = ::lookup_keyword(arg);
    }

    if (keyword == Keyword::ASMPC) {
        m_tokens.emplace_back(TType::ASMPC, blank_before);
    }
    else {
        m_tokens.emplace_back(TType::IDENT, blank_before);
        m_tokens.back().set_keyword(arg);
    }

    return true;
}

bool Scanner::read_number_literal(
    const char*& p,
    std::function<bool(char)> digit_predicate,
    int base,
    int& out_value,
    char required_suffix
) {
    string digits;

    while (digit_predicate((unsigned char)*p) || *p == '_') {
        if (*p != '_')
            digits.push_back(*p);
        ++p;
    }

    if (digits.empty()) {
        clear();
        return false;
    }

    if (required_suffix && toupper(required_suffix) == toupper((unsigned char)*p))
        ++p;

    if (!is_token_delimiter((unsigned char)*p)) {
        clear();
        return false;
    }

    try {
        long long val = std::stoll(digits, nullptr, base);
        if (val > static_cast<long long>(std::numeric_limits<int>::max())) {
            g_error->error_int_range(int_to_hex(val, 4));
            clear();
            return false;
        }
        out_value = static_cast<int>(val);
    }
    catch (...) {
        g_error->error_int_range(digits);
        clear();
        return false;
    }

    return true;
}

bool Scanner::looks_like_float(const char* p) {
    bool seen_dot = false;
    bool seen_exp = false;
    bool seen_digits_before_dot = false;
    bool seen_digits_after_dot = false;
    bool seen_digits_in_exp = false;

    const char* t = p;

    // Integer part
    while (*t == '_' || isdigit((unsigned char)*t)) {
        if (isdigit((unsigned char)*t))
            seen_digits_before_dot = true;
        ++t;
    }

    // Fractional part
    if (*t == '.') {
        seen_dot = true;
        ++t;
        while (*t == '_' || isdigit((unsigned char)*t)) {
            if (isdigit((unsigned char)*t))
                seen_digits_after_dot = true;
            ++t;
        }
    }

    // Must have valid mantissa (before handling exponent)
    bool valid_mantissa = (seen_digits_before_dot || seen_digits_after_dot);

    // Exponent part
    if ((*t == 'e' || *t == 'E') && valid_mantissa) {
        seen_exp = true;
        ++t;
        if (*t == '+' || *t == '-') ++t;
        while (*t == '_' || isdigit((unsigned char)*t)) {
            if (isdigit((unsigned char)*t))
                seen_digits_in_exp = true;
            ++t;
        }
    }

    // Valid float requires either:
    // - A dot with digits before or after it
    // - An exponent with digits
    bool valid_fraction = seen_dot && valid_mantissa;
    bool valid_exponent = seen_exp && seen_digits_in_exp;

    return valid_fraction || valid_exponent;
}

bool Scanner::read_float_literal(const char*& p, double& out_value) {
    const char* start = p;
    char* endptr = nullptr;
    out_value = std::strtod(start, &endptr);
    if (endptr == start) {
        clear();
        return false;
    }
    if (!is_token_delimiter(*endptr)) {
        clear();
        return false;
    }
    p = endptr;
    return true;
}

bool Scanner::scan_bitmask(const char*& p, bool blank_before) {
    string bits;

    while (*p != '"' && *p != '\0') {
        char c = *p++;
        if (c == '#')
            bits.push_back('1');
        else if (c == '-')
            bits.push_back('0');
        else {
            g_error->error_invalid_char(c);
            return false;
        }
        if (bits.size() > 8) {
            g_error->error_bitmask_too_long();
            return false;
        }
    }

    if (*p != '"') {
        g_error->error_unterminated_string();
        return false;
    }
    ++p; // consume closing quote

    // Convert bit string to integer
    int value = std::stoi(bits, nullptr, 2);
    m_tokens.emplace_back(TType::INT, blank_before);
    m_tokens.back().set_ivalue(value);
    return true;
}

bool Scanner::scan_operator(const char*& p, bool blank_before) {
    char c = *p++;

    auto emit = [&](Operator op) {
        m_tokens.emplace_back(TType::OPERATOR, blank_before);
        m_tokens.back().set_operator(op);
        };

    switch (c) {
    case '+': emit(Operator::PLUS); return true;
    case '-': emit(Operator::MINUS); return true;
    case '*':
        if (*p == '*') { ++p; emit(Operator::POWER); }
        else emit(Operator::MULT);
        return true;
    case '/': emit(Operator::DIV); return true;
    case '%': emit(Operator::MOD); return true;
    case '~': emit(Operator::BIN_NOT); return true;
    case '=':
        if (*p == '=') ++p;
        emit(Operator::EQ);
        return true;
    case '!':
        if (*p == '=') { ++p; emit(Operator::NE); }
        else emit(Operator::LOG_NOT);
        return true;
    case '&':
        if (*p == '&') { ++p; emit(Operator::LOG_AND); }
        else emit(Operator::BIN_AND);
        return true;
    case '|':
        if (*p == '|') { ++p; emit(Operator::LOG_OR); }
        else emit(Operator::BIN_OR);
        return true;
    case '^':
        if (*p == '^') { ++p; emit(Operator::LOG_XOR); }
        else emit(Operator::BIN_XOR);
        return true;
    case '<':
        if (*p == '=') { ++p; emit(Operator::LE); }
        else if (*p == '<') { ++p; emit(Operator::LSHIFT); }
        else if (*p == '>') { ++p; emit(Operator::NE); }
        else emit(Operator::LT);
        return true;
    case '>':
        if (*p == '=') { ++p; emit(Operator::GE); }
        else if (*p == '>') { ++p; emit(Operator::RSHIFT); }
        else emit(Operator::GT);
        return true;
    default:
        --p; // Not an operator
        return false;
    }
}

bool Scanner::scan_symbol(const char*& p, bool blank_before) {
    switch (*p) {
    case '$': m_tokens.emplace_back(TType::ASMPC, blank_before); ++p; return true;
    case '(': m_tokens.emplace_back(TType::LPAREN, blank_before); ++p; return true;
    case ')': m_tokens.emplace_back(TType::RPAREN, blank_before); ++p; return true;
    case ',': m_tokens.emplace_back(TType::COMMA, blank_before); ++p; return true;
    case '.': m_tokens.emplace_back(TType::DOT, blank_before); ++p; return true;
    case ':': m_tokens.emplace_back(TType::COLON, blank_before); ++p; return true;
    case '?': m_tokens.emplace_back(TType::QUEST, blank_before); ++p; return true;
    case '[': m_tokens.emplace_back(TType::LSQUARE, blank_before); ++p; return true;
    case ']': m_tokens.emplace_back(TType::RSQUARE, blank_before); ++p; return true;
    case '{': m_tokens.emplace_back(TType::LBRACE, blank_before); ++p; return true;
    case '}': m_tokens.emplace_back(TType::RBRACE, blank_before); ++p; return true;
    case '\\': m_tokens.emplace_back(TType::BACKSLASH, blank_before); ++p; return true;
    case '#':
        ++p;
        if (*p == '#') { ++p; m_tokens.emplace_back(TType::DHASH, blank_before); }
        else m_tokens.emplace_back(TType::HASH, blank_before);
        return true;
    default:
        return false;
    }
}

bool Scanner::scan_string_or_char(const char*& p, bool blank_before) {
    const char quote = *p;

    string arg;

    if (should_parse_raw_string()) {
        if (!scan_raw_string(p, arg)) {
            clear();
            return false;
        }
        m_tokens.emplace_back(TType::RAW_STR, blank_before);
        m_tokens.back().set_svalue(arg);
        return true;
    }

    if (!scan_c_string(p, arg)) {
        clear();
        return false;
    }

    if (quote == '\'' ) {
        if (arg.size() == 1) {
            m_tokens.emplace_back(TType::INT, blank_before);
            m_tokens.back().set_ivalue(static_cast<int>(arg[0]));
        }
        else {
            g_error->error_invalid_quoted_char();
            clear();
            return false;
        }
    }
    else {
        m_tokens.emplace_back(TType::STR, blank_before);
        m_tokens.back().set_svalue(arg);
    }

    return true;
}

bool Scanner::should_parse_raw_string() const {
    return !m_tokens.empty() &&
        (m_tokens.back().is(Keyword::INCLUDE) ||
            m_tokens.back().is(Keyword::BINARY) ||
            m_tokens.back().is(Keyword::INCBIN) ||
            m_tokens.back().is(Keyword::LINE) ||
            m_tokens.back().is(Keyword::C_LINE));
}

void Scanner::skip_comment(const char*& p) {
    ++p;
    while (*p && *p != '\n')
        ++p;
}

void Scanner::rewind() {
    m_pos = 0;
}

void Scanner::next(int num) {
    m_pos += num;
    if (m_pos > static_cast<int>(m_tokens.size()))
        m_pos = static_cast<int>(m_tokens.size());
}

const Token& Scanner::peek(int offset) const {
    static Token end;
    int pos = m_pos + offset;
    if (pos >= 0 && pos < static_cast<int>(m_tokens.size()))
        return m_tokens[pos];
    else
        return end;
}

const Token& Scanner::operator[](size_t pos) const {
    static Token end;
    if (pos < m_tokens.size())
        return m_tokens[pos];
    else
        return end;
}

Token& Scanner::front() {
    static Token end;
    if (m_tokens.empty())
        return end;
    else
        return m_tokens.front();
}

Token& Scanner::back() {
    static Token end;
    if (m_tokens.empty())
        return end;
    else
        return m_tokens.back();
}

bool Scanner::scan_raw_string(const char*& p, string& result) {
    char quote = *p++;
    result.clear();
    while (*p != quote && *p != '\0') {
        result += *p++;
    }
    if (*p != quote) {
        g_error->error_unterminated_string();
        result.clear();
        return false;
    }
    else {
        ++p;
    }

    return true;
}

bool Scanner::scan_c_string(const char*& p, string& result) {
    char quote = *p++;
    result.clear();
    while (*p != quote && *p != '\0') {
        if (*p == '\\') {
            ++p;
            if (*p == '\0') {
                g_error->error_unterminated_string();
                result.clear();
                return false;
            }
            else if (*p >= '0' && *p <= '7') {
                result += scan_octal(p);
            }
            else if (*p == 'x' && isxdigit((unsigned char)p[1])) {
                ++p; // skip 'x'
                result += scan_hex(p);
            }
            else {
                char result_char = '\0';
                if (scan_escape_char(*p++, result_char)) {
                    result += result_char;
                }
                else {
                    result.clear();
                    return false;
                }
            }
        }
        else {
            result += *p++;
        }
    }
    if (*p != quote) {
        g_error->error_unterminated_string();
        result.clear();
        return false;
    }
    else {
        ++p;
    }

    return true;
}

bool Scanner::scan_escape_char(char c, char& result) {
    result = '\0';
    switch (c) {
    case 'n':  result = '\n'; return true;
    case 't':  result = '\t'; return true;
    case 'r':  result = '\r'; return true;
    case 'b':  result = '\b'; return true;
    case 'f':  result = '\f'; return true;
    case 'a':  result = '\a'; return true;
    case 'v':  result = '\v'; return true;
    case 'e':  result = '\x1b'; return true;
    case '\\': result = '\\'; return true;
    case '\'': result = '\''; return true;
    case '\"': result = '\"'; return true;
    case '?':  result = '\?'; return true;
    default:
        g_error->error_invalid_escape_char(c);
        return false;
    }
}

char Scanner::scan_octal(const char*& p) {
    int value = 0;
    int count = 0;
    while (count < 3 && *p >= '0' && *p <= '7') {
        value = (value * 8) + (*p - '0');
        ++p;
        ++count;
    }
    return static_cast<char>(value);
}

char Scanner::scan_hex(const char*& p) {
    int value = 0;
    while (isxdigit((unsigned char)*p)) {
        value *= 16;
        if (*p >= '0' && *p <= '9') {
            value += (*p - '0');
        }
        else if (*p >= 'a' && *p <= 'f') {
            value += (*p - 'a' + 10);
        }
        else if (*p >= 'A' && *p <= 'F') {
            value += (*p - 'A' + 10);
        }
        ++p;
    }
    return static_cast<char>(value);
}

string Scanner::to_string() const {
    string result;
    for (auto& token : m_tokens) {
        result = Token::concat(result, token.to_string());
    }
    return result;
}

#ifdef UNIT_TESTS
void Scanner::test() {
    test_scanner_numeric_literals();
    test_identifiers_and_keywords();
    test_operators();
    test_symbols();
    test_string_literals();
    test_char_literal();
    test_special_tokens();
    test_newline_and_comments();
    test_negative_cases();
    test_float_scanner();

    cout << "Scanner tests passed." << endl;
}

void Scanner::assert_token(const Scanner& scanner, TType expected_ttype, int expected_ivalue) {
    assert(scanner.size() == 1);
    const Token& tok = scanner[0];
    assert(tok.ttype() == expected_ttype);
    assert(tok.ivalue() == expected_ivalue);
}

void Scanner::assert_token_count(const Scanner& scanner, size_t expected) {
    assert(scanner.size() == expected);
}

void Scanner::assert_token_type(const Scanner& scanner, size_t index, TType expected_type) {
    assert(index < scanner.size());
    assert(scanner[index].ttype() == expected_type);
}

void Scanner::assert_token_keyword(const Scanner& scanner, size_t index, const string& expected_kw) {
    assert(index < scanner.size());
    assert(::to_string(scanner[index].keyword()) == expected_kw);
}

void Scanner::assert_token_operator(const Scanner& scanner, size_t index, Operator expected_op) {
    assert(index < scanner.size());
    assert(scanner[index].operator_() == expected_op);
}

void Scanner::test_scanner_numeric_literals() {
    Scanner scanner;

    // --- Decimal ---
    assert(scanner.scan("42"));
    assert_token(scanner, TType::INT, 42);

    assert(scanner.scan("1_000_000"));
    assert_token(scanner, TType::INT, 1000000);

    // --- Hexadecimal ---
    assert(scanner.scan("0x2A"));
    assert_token(scanner, TType::INT, 42);

    assert(scanner.scan("0x0EAD_BEEF"));
    assert_token(scanner, TType::INT, 0x0EADBEEF);

    assert(scanner.scan("$2A"));
    assert_token(scanner, TType::INT, 0x2A);

    assert(scanner.scan("2Ah"));
    assert_token(scanner, TType::INT, 0x2A);

    assert(scanner.scan("0DE_ADh"));
    assert_token(scanner, TType::INT, 0xDEAD);

    // --- Binary ---
    assert(scanner.scan("0b101010"));
    assert_token(scanner, TType::INT, 0b101010);

    assert(scanner.scan("0b1010_1010"));
    assert_token(scanner, TType::INT, 0b10101010);

    assert(scanner.scan("%1010_1010"));
    assert_token(scanner, TType::INT, 0b10101010);

    assert(scanner.scan("@10101010"));
    assert_token(scanner, TType::INT, 0b10101010);

    assert(scanner.scan("10101010b"));
    assert_token(scanner, TType::INT, 0b10101010);

    assert(scanner.scan("1010_1010b"));
    assert_token(scanner, TType::INT, 0b10101010);

    // --- Bitmask Image ---
    assert(scanner.scan(R"(@"#--##--#")"));
    assert_token(scanner, TType::INT, 0b10011001);
}

void Scanner::test_identifiers_and_keywords() {
    Scanner scanner;
    assert(scanner.scan("myVar _label AF'"));
    assert_token_count(scanner, 3);
    assert_token_type(scanner, 0, TType::IDENT);
    assert_token_type(scanner, 1, TType::IDENT);
    assert_token_type(scanner, 2, TType::IDENT);
}

void Scanner::test_operators() {
    Scanner scanner;
    assert(scanner.scan("+ - * / % ~ ** == != && & || | << >> < > <= >= ^ ^^"));

    vector<Operator> expected_ops = {
        Operator::PLUS, Operator::MINUS, Operator::MULT, Operator::DIV, Operator::MOD, Operator::BIN_NOT,
        Operator::POWER, Operator::EQ, Operator::NE, Operator::LOG_AND, Operator::BIN_AND,
        Operator::LOG_OR, Operator::BIN_OR, Operator::LSHIFT, Operator::RSHIFT,
        Operator::LT, Operator::GT, Operator::LE, Operator::GE,
        Operator::BIN_XOR, Operator::LOG_XOR
    };

    assert_token_count(scanner, static_cast<int>(expected_ops.size()));

    for (int i = 0; i < static_cast<int>(expected_ops.size()); ++i)
        assert_token_operator(scanner, i, expected_ops[i]);
}

void Scanner::test_symbols() {
    Scanner scanner;
    assert(scanner.scan("() [] {} , . : ? \\ ## #"));

    vector<TType> expected = {
        TType::LPAREN, TType::RPAREN,
        TType::LSQUARE, TType::RSQUARE,
        TType::LBRACE, TType::RBRACE,
        TType::COMMA, TType::DOT, TType::COLON,
        TType::QUEST, TType::BACKSLASH,
        TType::DHASH, TType::HASH
    };

    assert_token_count(scanner, static_cast<int>(expected.size()));
    for (int i = 0; i < static_cast<int>(expected.size()); ++i)
        assert_token_type(scanner, i, expected[i]);
}

void Scanner::test_string_literals() {
    Scanner scanner;
    assert(scanner.scan("\"hello\""));
    assert_token_count(scanner, 1);
    assert_token_type(scanner, 0, TType::STR);
    assert(scanner[0].svalue() == "hello");
}

void Scanner::test_char_literal() {
    Scanner scanner;
    assert(scanner.scan("'a'"));
    assert_token_count(scanner, 1);
    assert_token_type(scanner, 0, TType::INT);
    assert(scanner[0].ivalue() == static_cast<int>('a'));
}

void Scanner::test_special_tokens() {
    Scanner scanner;
    assert(scanner.scan("$"));
    assert_token_count(scanner, 1);
    assert_token_type(scanner, 0, TType::ASMPC);

    assert(scanner.scan(R"(@"#--##--#")"));
    assert_token_count(scanner, 1);
    assert_token_type(scanner, 0, TType::INT);
    assert(scanner[0].ivalue() == 0b10011001);
}

void Scanner::test_newline_and_comments() {
    Scanner scanner;
    assert(scanner.scan("42\n"));
    assert_token_count(scanner, 2);
    assert_token_type(scanner, 0, TType::INT);
    assert_token_type(scanner, 1, TType::NEWLINE);

    assert(scanner.scan("42 ; this is a comment\n"));
    assert_token_count(scanner, 2);
    assert_token_type(scanner, 0, TType::INT);
    assert_token_type(scanner, 1, TType::NEWLINE);
}

void Scanner::test_negative_cases() {
    Scanner scanner;

    // Unterminated string
    assert(!scanner.scan("\"unterminated"));
    assert_token_count(scanner, 0);

    // Unterminated char literal
    assert(!scanner.scan("'a"));
    assert_token_count(scanner, 0);

    // Multi-char literal
    assert(!scanner.scan("'ab'"));
    assert_token_count(scanner, 0);

    // Invalid hex (bad digit)
    assert(!scanner.scan("0xG1"));
    assert_token_count(scanner, 0);

    // Hex prefix with no digits
    assert(!scanner.scan("0x"));
    assert_token_count(scanner, 0);

    // Dollar hex with no digits
    assert(scanner.scan("$"));
    assert_token_count(scanner, 1);
    assert_token_type(scanner, 0, TType::ASMPC);

    // Bad binary digit
    assert(!scanner.scan("0b012"));
    assert_token_count(scanner, 0);

    // Binary prefix with no digits
    assert(!scanner.scan("0b"));
    assert_token_count(scanner, 0);

    // Invalid suffix
    assert(!scanner.scan("42x"));
    assert_token_count(scanner, 0);

    // Lone @ (not followed by digits or string)
    assert(!scanner.scan("@"));
    assert_token_count(scanner, 0);

    // underscore is an indentifier
    assert(scanner.scan("_"));
    assert_token_count(scanner, 1);
    assert_token_type(scanner, 0, TType::IDENT);

    // Non-ASCII character
    assert(!scanner.scan("©"));
    assert_token_count(scanner, 0);

    // integer followed by float
    assert(scanner.scan("1+.3"));
    assert_token_count(scanner, 3);
    assert_token_type(scanner, 0, TType::INT);
    assert_token_type(scanner, 1, TType::OPERATOR);
    assert_token_type(scanner, 2, TType::FLOAT);

    // invalid float
    assert(scanner.scan(".e3"));
    assert_token_count(scanner, 2);
    assert_token_type(scanner, 0, TType::DOT);
    assert_token_type(scanner, 1, TType::IDENT);
}

void Scanner::test_float_scanner() {
    Scanner scanner;

    auto test = [&](const string& input, double expected) {
        bool ok = scanner.scan(input);
        assert(ok);
        assert(scanner.size() == 1);
        assert(scanner[0].ttype() == TType::FLOAT);
        assert(std::abs(scanner[0].fvalue() - expected) < 1e-10);
        };

    test("0.5", 0.5);
    test("3.14", 3.14);
    test("2e10", 2e10);
    test("1.0E-5", 1.0e-5);
    test("123.456e+2", 123.456e+2);
    test(".25", 0.25);
    test("5.", 5.0);
}

#endif


