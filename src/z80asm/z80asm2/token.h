//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "operator.h"
#include <string>
using namespace std;

enum class TType {
    //@@BEGIN: ttype
    END,
    ASMPC,
    BACKSLASH,
    COLON,
    COMMA,
    CONST_EXPR,
    DHASH,
    DOT,
    EXPR,
    FLOAT,
    HASH,
    IDENT,
    INT,
    LBRACE,
    LPAREN,
    LSQUARE,
    NEWLINE,
    OPERATOR,
    QUEST,
    RAW_STR,
    RBRACE,
    RPAREN,
    RSQUARE,
    STR,
    //@@END
};

string to_string(TType ttype);

enum class Keyword {
    //@@BEGIN: keyword
    NONE,
    A,
    ASMPC,
    ASSUME,
    B,
    BINARY,
    C,
    C_LINE,
    EQU,
    INCBIN,
    INCLUDE,
    JR,
    LD,
    LINE,
    NC,
    NOP,
    NZ,
    Z,
    //@@END
};

string to_string(Keyword keyword);
Keyword lookup_keyword(const string& text);

class Token {
public:
    Token() {}
    Token(TType ttype, bool blank_before);
    TType ttype() const { return m_ttype; }
    bool blank_before() const { return m_blank_before; }

    int ivalue() const { return m_ivalue; }
    double fvalue() const { return m_fvalue; }
    const string& svalue() const { return m_svalue; }
    Keyword keyword() const { return m_keyword; }
    Operator operator_() const { return m_operator; }

    void set_ivalue(int ivalue) { m_ivalue = ivalue; }
    void set_fvalue(double fvalue) { m_fvalue = fvalue; }
    void set_svalue(const string& svalue) { m_svalue = svalue; }
    void set_keyword(const string& text);
    void set_operator(Operator op) { m_operator = op; }

    bool is(TType ttype) const { return m_ttype == ttype; }
    bool is(Keyword keyword) const { return m_keyword == keyword; }
    bool is_end() const;

    string to_string() const;

    static string concat(const string& s1, const string& s2);

private:
    TType m_ttype{ TType::END };
    bool m_blank_before{ false };
    Keyword m_keyword{ Keyword::NONE };
    Operator m_operator{ Operator::NONE };
    int m_ivalue{ 0 };
    double m_fvalue{ 0.0 };
    string m_svalue;
};

