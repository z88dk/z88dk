//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cctype>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
using namespace std;

#if __has_include(<filesystem>)
// std::filesystem from C++17
#include <filesystem>
namespace fs = std::filesystem;
#else
// boost::filesystem from Boost
#include <boost/filesystem.hpp>
namespace fs = boost::filesystem;
#endif

inline bool is_eol(char c) { return c == '\r' || c == '\n'; }
inline bool is_ident_start(char c) { return c == '_' || c == '@' || isalpha(c); }
inline bool is_ident(char c) { return c == '_' || c == '@' || isalnum(c); }

bool is_ident(const string& ident);
int char_digit(char c);
bool str_ends_with(const string& str, const string& ending);

string str_tolower(string str);
string str_toupper(string str);
string str_strip(const string& str);				// remove start and end blanks
string str_chomp(const string& str);				// remove end blanks
string str_remove_all_blanks(const string& str);	// remove all blanks
string str_remove_extra_blanks(const string& str);	// replace sequences of blanks with one space
string str_replace_all(string text, const string& find, const string& replace);

// globs a pattern including *, ? and ** and returns all matching files and directories
void expand_glob(vector<fs::path>& result, const string& pattern);

istream& safe_getline(istream& is, string& t);

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

std::string pop_end_slash(std::string path);
std::string join_dir(const std::string& a, const std::string& b);
