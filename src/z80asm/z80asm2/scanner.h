//-----------------------------------------------------------------------------
// z80asm
// Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "token.h"
#include <vector>
using namespace std;

class Scanner {
public:
    Scanner() {}
    Scanner(const vector<Token>& tokens);
    bool scan(const string& text);
    void clear();
    void rewind();
    void next(int num = 1);
    Token& peek(int offset = 0);
    Token& operator[](int pos);
    Token& front();
    Token& back();
    void push_back(const Token& token) { m_tokens.push_back(token); } // copy
    void push_back(Token&& token) { m_tokens.push_back(std::move(token)); } // move
    int get_pos() const { return m_pos; }
    void set_pos(int pos) { m_pos = pos; }
    size_t size() const { return m_tokens.size(); }
    string to_string() const;

private:
    vector<Token> m_tokens;
    int m_pos{ 0 };

    bool parse_raw_string(const char*& p, string& result);
    bool parse_c_string(const char*& p, string& result);
    bool parse_escape_char(char c, char& result);
    char parse_octal(const char*& p);
    char parse_hex(const char*& p);
};

