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
#include <vector>
using namespace std;

// number of elements of array
#define NUM_ELEMS(a)    (sizeof(a) / sizeof(a[0]))

// convert argument to string
#define TOSTR(x)	_TOSTR(x)
#define _TOSTR(x)	#x

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
string str_replace_all(string text, const string& find, const string& replace);

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
