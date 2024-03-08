//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>
using namespace std;

// token codes
enum TkCode {
#define TK(id, text)    id,
#include "scan.def"
};

enum Keyword {
#define KW(id, text)    id,
#include "scan.def"
};

Keyword keyword_lookup(const string& text);

// token
struct Token {
    TkCode  code{ TK_END };             // token code
    Keyword keyword{ KW_NONE };         // keyword value, if any
    int     ivalue{ 0 };                // integer value, if any
    double  fvalue{ 0.0 };              // floating point value, if any
    string  svalue;                     // string value, if any
    bool    blank_before{ false };      // has a blank before

    Token(TkCode code_, bool blank_before_, int ivalue_ = 0);
    Token(TkCode code_, bool blank_before_, double fvalue_);
    Token(TkCode code_, bool blank_before_, const string& svalue_);

    string to_string() const;
    static string to_string(const vector<Token>& tokens);
    static string concat(const string& s1, const string& s2);
    static string c_string(const string& text);

    bool is(TkCode code_) { return code == code_; }
    bool is(Keyword keyword_) { return keyword == keyword_; }
    template <typename T, typename... Types>
    bool is(T var1, Types... var2) {
        if (is(var1))
            return true;
        else if (is(var2...))
            return true;
        else
            return false;
    }
};

struct Scanner {
    vector<Token> tokens;
    int pos{ 0 };

    Scanner(const string& text) { set_text(text); }
    void clear() { tokens.clear(); pos = 0; }
    bool set_text(const string& text);      // false if error scanning
    string get_text() const;
    const Token& peek(int i = 0);
    void next(int n = 1) { pos += n; }
};
