//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "scan.h"
#include "z80asm.h"

//-----------------------------------------------------------------------------
// Token
//-----------------------------------------------------------------------------

ostream& operator<<(ostream& os, TType ttype) {
    os << static_cast<int>(ttype);
    return os;
}

ostream& operator<<(ostream& os, Keyword keyword) {
    os << static_cast<int>(keyword);
    return os;
}

Keyword keyword_lookup(const string& text) {
    static unordered_map<string, Keyword> keywords = {
#define XKEYWORD(id, text)      { text, Keyword::id },
#include "scan.def"
    };

    auto it = keywords.find(str_tolower(text));
    if (it == keywords.end())
        return Keyword::None;
    else
        return it->second;
}

Token::Token(TType ttype_, bool blank_before_, int i_value_)
    : ttype(ttype_)
    , keyword(Keyword::None)
    , i_value(i_value_)
    , f_value(0.0)
    , s_value("")
    , blank_before(blank_before_) {
}

Token::Token(TType ttype_, bool blank_before_, double f_value_)
    : ttype(ttype_)
    , keyword(Keyword::None)
    , i_value(0)
    , f_value(f_value_)
    , s_value("")
    , blank_before(blank_before_) {
}

Token::Token(TType ttype_, bool blank_before_, const string& s_value_)
    : ttype(ttype_)
    , keyword(Keyword::None)
    , i_value(0)
    , f_value(0.0)
    , s_value(s_value_)
    , blank_before(blank_before_) {
    keyword = keyword_lookup(s_value_);
}

Token::Token(TType ttype_, bool blank_before_, const string& s_value_, Keyword keyword_)
    : ttype(ttype_)
    , keyword(keyword_)
    , i_value(0)
    , f_value(0.0)
    , s_value(s_value_)
    , blank_before(blank_before_) {
}

string Token::to_string() const {
    static const char* tokens[] = {
#define XTOKEN(id, text)    text,
#include "scan.def"
    };

    size_t idx = 0;
    switch (ttype) {
    case TType::Ident: return s_value;
    case TType::Integer: return std::to_string(i_value);
    case TType::Floating: return std::to_string(f_value);
    case TType::String: return str_to_cstr(s_value);
    default:
        idx = static_cast<size_t>(ttype);
        xassert(idx < NUM_ELEMS(tokens));
        return tokens[idx];
    }
}

static string concat(const string& s1, const string& s2) {
    if (s1.empty() || s2.empty())
        return s1 + s2;
    else if (str_ends_with(s1, "##"))   // cpp-style concatenation
        return str_chomp(s1.substr(0, s1.length() - 2)) + s2;
    else if (is_space(s1.back()) || is_space(s2.front()))
        return s1 + s2;
    else if (is_ident(s1.back()) && is_ident(s2.front()))
        return s1 + " " + s2;
    else {
        switch (s1.back()) {
        case '!':
        case '#':
        case '$':
        case '%':
        case '&':
        case '*':
        case '@':
        case '^':
        case '|':
        case '<':
        case '=':
        case '>':
            return s1 + " " + s2;
        default:
            return s1 + s2;
        }
    }
}

string to_string(const Token& token) {
    return token.to_string();
}

string to_string(vector<Token>::const_iterator begin, vector<Token>::const_iterator end) {
    string out = "";
    for (auto it = begin; it != end; ++it) {
        string next = it->to_string();
        out = concat(out, next);
    }
    return out;
}
