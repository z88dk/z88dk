//-----------------------------------------------------------------------------
// z80asm - scanner
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

class Symbol;

// token
class Token {
public:
    Token(TkCode code = TK_END, bool blank_before = false, int ivalue = 0);
    Token(TkCode code, bool blank_before, double fvalue);
    Token(TkCode code, bool blank_before, const string& svalue);

    TkCode code() const;
    Keyword keyword() const;
    int ivalue() const;
    double fvalue() const;
    string svalue() const;
    bool blank_before() const;
    Symbol* symbol() const;

    void set_code(TkCode code);
    void set_ivalue(int ivalue);
    void set_fvalue(double fvalue);
    void set_svalue(const string& svalue);
    void set_symbol(Symbol* symbol);

    string to_string() const;
    static string to_string(const vector<Token>& tokens);
    static string concat(const string& s1, const string& s2);
    static string c_string(const string& text);

private:
    TkCode  code_{ TK_END };            // token code
    Keyword keyword_{ KW_NONE };        // keyword value, if any
    int     ivalue_{ 0 };               // integer value, if any
    double  fvalue_{ 0.0 };             // floating point value, if any
    string  svalue_;                    // string value, if any
    bool    blank_before_{ false };     // has a blank before
    Symbol* symbol_{ nullptr };         // pointer to symbol if identifier
};

// scanner
class Lexer {
public:
    Lexer(const string& text = "");
    void clear();
    bool set_text(const string& text);  // false if error scanning
    string text() const;
    string peek_text(int idx = 0) const;
    const Token& peek(int idx = 0);
    void next(int n = 1);
    bool at_end() const;
    void flush();

private:
    vector<Token> tokens_;
    int pos_{ 0 };
};
