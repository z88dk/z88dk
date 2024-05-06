//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <algorithm>
#include <cctype>
#include <iostream>
#include <sstream>
#include <vector>
using namespace std;

//-----------------------------------------------------------------------------

bool is_ident_start(char c) {
    return c == '_' || isalpha(c);
}

bool is_ident(char c) {
    return c == '_' || c == '$' || isalnum(c);
}

bool is_ident(const string& ident) {
    if (ident.empty())
        return false;
    else if (!is_ident_start(ident[0]))
        return false;
    else {
        for (auto c : ident) {
            if (!is_ident(c))
                return false;
        }
        return true;
    }
}

int char_digit(char c) {
    return isdigit(c) ? c - '0' : isxdigit(c) ? 10 + toupper(c) - 'A' : -1;
}

//-----------------------------------------------------------------------------

bool str_begins_with(const string& str, const string& beginning) {
    if (str.length() >= beginning.length())
        return (0 == str.compare(0, beginning.length(), beginning));
    else
    return false;
}

bool str_ends_with(const string& str, const string& ending) {
    if (str.length() >= ending.length())
        return (0 == str.compare(str.length() - ending.length(), ending.length(), ending));
    else
        return false;
}

string str_tolower(string str) {
    transform(str.begin(), str.end(), str.begin(), [](char c) {return tolower(c); });
    return str;
}

string str_toupper(string str) {
    transform(str.begin(), str.end(), str.begin(), [](char c) {return toupper(c); });
    return str;
}

string str_chomp(const string& str_) {
    string str = str_;
    while (!str.empty() && isspace(str.back()))
        str.pop_back();
    return str;
}

string str_strip(const string& str) {
    const char* p = str.c_str();
    while (*p && isspace(*p))
        p++;
    return str_chomp(p);
}

string str_remove_extra_blanks(const string& str) {
    string out;
    for (const char* p = str.c_str(); *p != '\0'; p++) {
        if (!isspace(*p))
            out.push_back(*p);
        else {
            out.push_back(' ');
            while (isspace(p[1]))
                p++;
        }
    }
    return str_strip(out);
}

string str_remove_all_blanks(const string& str) {
    string out;
    for (auto c : str)
        if (!isspace(c))
            out.push_back(c);
    return out;
}

string str_replace_all(string text, const string& find, const string& replace) {
    if (text.empty() || find.empty())
        return text;

    size_t p = 0;
    while ((p = text.find(find, p)) != string::npos) {
        text.replace(p, find.length(), replace);
        p += replace.length();
    }
    return text;
}

//-----------------------------------------------------------------------------

istream& safe_getline(istream& is, string& t) {
    t.clear();

    // The characters in the stream are read one-by-one using a streambuf.
    // That is faster than reading them one-by-one using the istream.
    // Code that uses streambuf this way must be guarded by a sentry object.
    // The sentry object performs various tasks,
    // such as thread synchronization and updating the stream state.

    istream::sentry se(is, true);
    streambuf* sb = is.rdbuf();

    for (;;) {
        int c = sb->sbumpc();
        switch (c) {
        case '\n':
            return is;
        case '\r':
            if (sb->sgetc() == '\n')
                sb->sbumpc();
            return is;
        case streambuf::traits_type::eof():
            // Also handle the case when the last line has no line ending
            if (t.empty())
                is.setstate(ios::eofbit);
            return is;
        default:
            t += (char)c;
        }
    }
}

//-----------------------------------------------------------------------------

int ipow(int base, int exp) {
    if (exp < 0)
        return 0;
    else {
        int result = 1;
        for (;;) {
            if (exp & 1)
                result *= base;
            exp >>= 1;
            if (!exp)
                break;
            base *= base;
        }
        return result;
    }
}

