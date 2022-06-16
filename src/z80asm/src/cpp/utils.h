//-----------------------------------------------------------------------------
// z80asm
// utils
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <iomanip> 
#include <sstream>
#include <string>
#include <vector>
using namespace std;

#if __has_include(<filesystem>)
	// std::filesystem from C++17
	#include <filesystem>
	namespace fs = std::filesystem;
#else
	#include <experimental/filesystem>
	namespace fs = std::experimental::filesystem;
#endif

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

// read lines with any EOL terminator
istream& safe_getline(istream& is, string& t);

// convert int to hex
// https://stackoverflow.com/questions/5100718/integer-to-hex-string-in-c
template<typename T>
string int_to_hex(T i)
{
	std::ostringstream ss;
	if (i < 10)
		ss << i;
	else
		ss << "0x"
		<< std::setfill('0') << std::setw(2)
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
