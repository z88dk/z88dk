//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>
using namespace std;

#if 0
class Tokens {
public:
    int pos{ 0 };
    bool is_ok{ true };             // false if scan failed

    Token& operator[](int offset);  // TType::End if before or after token string

    Tokens(const string& text = "");
    Tokens(const vector<Token>& tokens);
    void clear();

    void push_back(const string& text);
    void push_back(const Tokens& other);

    void rewind() { pos = 0; }
    bool at_end() { return static_cast<size_t> (pos) >= m_tokens.size(); }

    string to_string() const;

    auto begin() { return m_tokens.begin(); }
    auto end() { return m_tokens.end(); }
    auto cbegin() const { return m_tokens.cbegin(); }
    auto cend() const { return m_tokens.cend(); }
    auto size() { return m_tokens.size(); }
    auto empty() { return m_tokens.empty(); }

    Tokens peek_tokens(int offset = 0);

private:
    vector<Token> m_tokens;

    static string concat(const string& s1, const string& s2);
};

string to_string(const Tokens& tokens);
#endif
