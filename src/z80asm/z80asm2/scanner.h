//-----------------------------------------------------------------------------
// z80asm
// Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "token.h"
#include <functional>
#include <vector>
using namespace std;

class Scanner {
public:
    Scanner() = default;
    Scanner(const vector<Token>& tokens);
    bool scan(const string& text);
    void clear();
    void rewind();
    void next(int num = 1);
    const Token& peek(int offset = 0) const;
    const Token& operator[](size_t pos) const;
    Token& front();
    Token& back();
    void push_back(const Token& token) { m_tokens.push_back(token); } // copy
    void push_back(Token&& token) { m_tokens.push_back(std::move(token)); } // move
    int pos() const { return m_pos; }
    void set_pos(int pos) { m_pos = pos; }
    size_t size() const { return m_tokens.size(); }
    string to_string() const;

#ifdef UNIT_TESTS
    static void test();
#endif

private:
    vector<Token> m_tokens;
    int m_pos{ 0 };

    bool scan_identifier_or_keyword(const char*& p, bool blank_before);
    bool read_number_literal(const char*& p,
        std::function<bool(char)> digit_predicate,
        int base,
        int& out_value,
        char required_suffix = 0);
    bool looks_like_float(const char* p);
    bool read_float_literal(const char*& p, double& out_value);
    bool scan_bitmask(const char*& p, bool blank_before);
    bool scan_operator(const char*& p, bool blank_before);
    bool scan_symbol(const char*& p, bool blank_before);
    bool scan_string_or_char(const char*& p, bool blank_before);
    bool should_parse_raw_string() const;
    void skip_comment(const char*& p);
    bool scan_raw_string(const char*& p, string& result);
    bool scan_c_string(const char*& p, string& result);
    bool scan_escape_char(char c, char& result);
    char scan_octal(const char*& p);
    char scan_hex(const char*& p);

#ifdef UNIT_TESTS
    static void assert_token(const Scanner& scanner, TType expected_type, int expected_ivalue);
    static void assert_token_count(const Scanner& scanner, size_t expected);
    static void assert_token_type(const Scanner& scanner, size_t index, TType expected_type);
    static void assert_token_keyword(const Scanner& scanner, size_t index, const std::string& expected_kw);
    static void assert_token_operator(const Scanner& scanner, size_t index, Operator expected_op);
    static void test_scanner_numeric_literals();
    static void test_identifiers_and_keywords();
    static void test_operators();
    static void test_symbols();
    static void test_string_literals();
    static void test_char_literal();
    static void test_special_tokens();
    static void test_newline_and_comments();
    static void test_negative_cases();
    static void test_float_scanner();

#endif
};

