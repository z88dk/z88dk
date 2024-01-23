//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include <string>
#include <vector>
using namespace std;

// token types
enum class TType {
#define XTOKEN(id, text)     id,
#include "scan.def"
};

ostream& operator<<(ostream& os, TType ttype);

enum class Keyword {
#define XKEYWORD(id, text)		id,
#include "scan.def"
};

ostream& operator<<(ostream& os, Keyword keyword);

Keyword keyword_lookup(const string& text);

struct Token {
    TType   ttype{ TType::End };
    Keyword keyword{ Keyword::None };
    int     i_value{ 0 };
    double  f_value{ 0.0 };
    PoolStr s_value;
    bool    blank_before{ false };

    Token(TType ttype_, bool blank_before_, int i_value_ = 0);
    Token(TType ttype_, bool blank_before_, double f_value_);
    Token(TType ttype_, bool blank_before_, const string& s_value_);
    Token(TType ttype_, bool blank_before_, const string& s_value_, Keyword keyword_);

    string to_string() const;
};

string to_string(const Token& token);
string to_string(vector<Token>::const_iterator begin, vector<Token>::const_iterator end);

