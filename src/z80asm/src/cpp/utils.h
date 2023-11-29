//-----------------------------------------------------------------------------
// z80asm
// utils
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "if.h"
#include <iostream>
#include <iomanip> 
#include <sstream>
#include <string>
#include <vector>
#include <cctype>
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

// ctype.h on MSVC asserts that character is in range -1 to 255; this fails for signed chars
inline bool is_alnum(char c) { return c > 0 && isalnum(c); }
inline bool is_alpha(char c) { return c > 0 && isalpha(c); }
inline bool is_cntrl(char c) { return c > 0 && iscntrl(c); }
inline bool is_digit(char c) { return c > 0 && isdigit(c); }
inline bool is_graph(char c) { return c > 0 && isgraph(c); }
inline bool is_lower(char c) { return c > 0 && islower(c); }
inline bool is_print(char c) { return c > 0 && isprint(c); }
inline bool is_punct(char c) { return c > 0 && ispunct(c); }
inline bool is_space(char c) { return c > 0 && isspace(c); }
inline bool is_upper(char c) { return c > 0 && isupper(c); }
inline bool is_xdigit(char c){ return c > 0 && isxdigit(c); }
inline char to_lower(char c) { return c > 0 ? tolower(c) : c; }
inline char to_upper(char c) { return c > 0 ? toupper(c) : c; }
inline bool is_blank(char c) { return c > 0 && isblank(c); }
inline bool is_eol(char c) { return c == '\r' || c == '\n'; }
inline bool is_ident_start(char c) { return c == '_' || is_alpha(c); }
inline bool is_ident(char c) { return c == '_' || is_alnum(c); }

bool is_ident(const string& ident);
int char_digit(char c);

// change case
string str_tolower(string str);
string str_toupper(string str);

// convert C-escape sequences
string str_compress_escapes(const string& in);
string str_expand_escapes(const string& in);

// check string ending
bool str_ends_with(const string& str, const string& ending);
string str_chomp(const string& str);				// remove end blanks
string str_strip(const string& str);				// remove start and end blanks
string str_remove_all_blanks(const string& str);	// remove all blanks
string str_remove_extra_blanks(const string& str);	// replace sequences of blanks with one space

// search_replace
string str_replace_all(string text, const string& find, const string& replace);

// globs a pattern including *, ? and ** and returns all matching files and directories
void expand_glob(vector<fs::path>& result, const string& pattern);

// integer power function
int ipow(int base, int exp);

// convert int to hex
// https://stackoverflow.com/questions/5100718/integer-to-hex-string-in-c
template<typename T>
string int_to_hex(T i, int width)
{
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

// convert vector of integers to string of comma-separated values
template<typename T>
string vector_to_csv(vector<T> items) {
	string out;
	for (auto item : items)
		out += std::to_string(item) + ",";
	if (!out.empty())
		out.pop_back();		// remove end comma
	return out;
}

// read/write binary data from/to streams
void swrite_int16(int n, ostream& os);
void swrite_int32(int n, ostream& os);
void swrite_string(const string& s, ostream& os);

int sread_int32(istream& is);
string sread_string(istream& is);
