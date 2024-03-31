//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
using namespace std;

bool is_ident_start(char c);
bool is_ident(char c);
bool is_ident(const string& ident);
int char_digit(char c);

bool str_begins_with(const string& str, const string& beginning);
bool str_ends_with(const string& str, const string& ending);
string str_tolower(string str);
string str_toupper(string str);
string str_chomp(const string& str);
string str_strip(const string& str);
string str_remove_extra_blanks(const string& str);
string str_remove_all_blanks(const string& str);

istream& safe_getline(istream& is, string& t);

int ipow(int base, int exp);

// convert int to hex
template<typename T>
string int_to_hex(T i, int width) {
    std::ostringstream ss;
    if (i <= -10)
        ss << "-$"
        << std::setfill('0') << std::setw(width)
        << std::hex << -i << std::dec;
    else if (i < 10)
        ss << i;
    else
        ss << "$"
        << std::setfill('0') << std::setw(width)
        << std::hex << i << std::dec;
    return ss.str();
}
