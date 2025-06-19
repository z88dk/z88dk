//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "token.h"
#include "utils.h"
#include <unordered_map>
using namespace std;

string to_string(TType ttype) {
    static unordered_map<TType, string> ttypes = {
        //@@BEGIN: ttype_text
        { TType::ASMPC, "$" },
        { TType::BACKSLASH, "\\" },
        { TType::COLON, ":" },
        { TType::COMMA, "," },
        { TType::CONST_EXPR, "" },
        { TType::DHASH, "##" },
        { TType::DOT, "." },
        { TType::END, "" },
        { TType::EXPR, "" },
        { TType::FLOAT, "" },
        { TType::HASH, "#" },
        { TType::IDENT, "" },
        { TType::INT, "" },
        { TType::LBRACE, "{" },
        { TType::LPAREN, "(" },
        { TType::LSQUARE, "[" },
        { TType::NEWLINE, "\n" },
        { TType::OPERATOR, "" },
        { TType::QUEST, "?" },
        { TType::RAW_STR, "" },
        { TType::RBRACE, "}" },
        { TType::RPAREN, ")" },
        { TType::RSQUARE, "]" },
        { TType::STR, "" },
        //@@END
    };

    auto it = ttypes.find(ttype);
    if (it == ttypes.end())
        return "";
    else
        return it->second;
}

string to_string(Keyword keyword) {
    static unordered_map<Keyword, string> keywords = {
        //@@BEGIN: keyword_text
        { Keyword::A, "a" },
        { Keyword::ASMPC, "asmpc" },
        { Keyword::ASSUME, "assume" },
        { Keyword::B, "b" },
        { Keyword::BINARY, "binary" },
        { Keyword::C, "c" },
        { Keyword::C_LINE, "c_line" },
        { Keyword::DEFB, "defb" },
        { Keyword::DEFC, "defc" },
        { Keyword::DEFINE, "define" },
        { Keyword::DEFP, "defp" },
        { Keyword::DEFQ, "defq" },
        { Keyword::DEFW, "defw" },
        { Keyword::EQU, "equ" },
        { Keyword::INCBIN, "incbin" },
        { Keyword::INCLUDE, "include" },
        { Keyword::JR, "jr" },
        { Keyword::LD, "ld" },
        { Keyword::LINE, "line" },
        { Keyword::NC, "nc" },
        { Keyword::NONE, "" },
        { Keyword::NOP, "nop" },
        { Keyword::NZ, "nz" },
        { Keyword::Z, "z" },
        //@@END
    };

    auto it = keywords.find(keyword);
    if (it == keywords.end())
        return "";
    else
        return it->second;

}

Keyword lookup_keyword(const string& text) {
    static unordered_map<string, Keyword> keywords = {
        //@@BEGIN: keyword_lookup
        { "a", Keyword::A },
        { "asmpc", Keyword::ASMPC },
        { "assume", Keyword::ASSUME },
        { "b", Keyword::B },
        { "binary", Keyword::BINARY },
        { "c", Keyword::C },
        { "c_line", Keyword::C_LINE },
        { "defb", Keyword::DEFB },
        { "defc", Keyword::DEFC },
        { "define", Keyword::DEFINE },
        { "defp", Keyword::DEFP },
        { "defq", Keyword::DEFQ },
        { "defw", Keyword::DEFW },
        { "equ", Keyword::EQU },
        { "incbin", Keyword::INCBIN },
        { "include", Keyword::INCLUDE },
        { "jr", Keyword::JR },
        { "ld", Keyword::LD },
        { "line", Keyword::LINE },
        { "nc", Keyword::NC },
        { "", Keyword::NONE },
        { "nop", Keyword::NOP },
        { "nz", Keyword::NZ },
        { "z", Keyword::Z },
        //@@END
    };

    auto it = keywords.find(str_to_lower(text));
    if (it == keywords.end())
        return Keyword::NONE;
    else
        return it->second;
}

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

