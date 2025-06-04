//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "token.h"
#include "utils.h"
using namespace std;

Token::Token(TType ttype, bool blank_before)
    : m_ttype(ttype), m_blank_before(blank_before) {
}

void Token::set_keyword(const string& text) {
    m_keyword = ::lookup_keyword(text);
    m_svalue = text;
}

bool Token::is_end() const {
    return is(TType::END) || is(TType::NEWLINE) || is(TType::COLON) || is(TType::BACKSLASH);
}

string Token::to_string() const {
    switch (m_ttype) {
    case TType::IDENT:
        return m_svalue;
    case TType::INT:
        return std::to_string(m_ivalue);
    case TType::FLOAT:
        return std::to_string(m_fvalue);
    case TType::STR:
        return binary_to_c_string(reinterpret_cast<const unsigned char*>(m_svalue.c_str()), m_svalue.size());
    case TType::RAW_STR:
        return "\"" + m_svalue + "\"";		// syntax error in a later stage if string contains '"'
    case TType::OPERATOR:
        return ::to_string(m_operator);
    default:
        return ::to_string(m_ttype);
    }
}

string Token::concat(const string& s1, const string& s2) {
    if (s1.empty() || s2.empty())
        return s1 + s2;
    else if (str_ends_with(s1, "##"))   // cpp-style concatenation
        return s1.substr(0, s1.length() - 2) + s2;
    else if (isspace(s1.back()) || isspace(s2.front()))
        return s1 + s2;
    else if (is_ident(s1.back()) && is_ident(s2.front()))
        return s1 + " " + s2;
    else if (s1.back() == '$' && isxdigit(s2.front()))
        return s1 + " " + s2;
    else if ((s1.back() == '%' || s1.back() == '@') &&
        (isdigit(s2.front()) || s2.front() == '"'))
        return s1 + " " + s2;
    else if ((s1.back() == '&' && s2.front() == '&') ||
        (s1.back() == '|' && s2.front() == '|') ||
        (s1.back() == '^' && s2.front() == '^') ||
        (s1.back() == '*' && s2.front() == '*') ||
        (s1.back() == '<' && (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
        (s1.back() == '>' && (s2.front() == '=' || s2.front() == '>')) ||
        (s1.back() == '=' && s2.front() == '=') ||
        (s1.back() == '!' && s2.front() == '=') ||
        (s1.back() == '#' && s2.front() == '#'))
        return s1 + " " + s2;
    else
        return s1 + s2;
}

