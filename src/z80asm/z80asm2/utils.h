//-----------------------------------------------------------------------------
// z80asm
// Utilities
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
using namespace std;

string str_to_lower(string input);
bool str_ends_with(const string& str, const string& ending);
string binary_to_c_string(const unsigned char* data, size_t length);
bool is_ident(char c);
bool read_custom_line(ifstream& stream, string& line);
int ipow(int base, int exp);
string sanitize_pathname(string path);
string replace_extension(string path, const string& new_ext);
string remove_extension(const string& path);
string dirname(const string& path);
string basename(const string& path);
bool different_sign(int x1, int x2);
string get_envvar(const string& key);
vector<string> split_by_whitespace(const string& input);

// convert int to hex
template<typename T>
string int_to_hex(T i, int width) {
    ostringstream ss;
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
