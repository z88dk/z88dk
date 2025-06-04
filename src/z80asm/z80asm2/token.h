//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "keyword.h"
#include "operator.h"
#include "ttype.h"
#include <string>
using namespace std;

class Token {
public:
    Token() {}
    Token(TType ttype, bool blank_before);
    TType get_ttype() const { return m_ttype; }
    bool has_blank_before() const { return m_blank_before; }

    int get_ivalue() const { return m_ivalue; }
    double get_fvalue() const { return m_fvalue; }
    const string& get_svalue() const { return m_svalue; }
    Keyword get_keyword() const { return m_keyword; }
    Operator get_operator() const { return m_operator; }

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

