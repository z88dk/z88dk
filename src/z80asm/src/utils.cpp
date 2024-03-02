//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include <cctype>
using namespace std;

string str_strip(const string& str) {
    const char* p = str.c_str();
    while (*p && isspace(*p))
        p++;
    return str_chomp(p);
}

string str_chomp(const string& str_) {
    string str = str_;
    while (!str.empty() && isspace(str.back()))
        str.pop_back();
    return str;
}

string str_remove_all_blanks(const string& str) {
    string out;
    for (auto c : str)
        if (!isspace(c))
            out.push_back(c);
    return out;
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

