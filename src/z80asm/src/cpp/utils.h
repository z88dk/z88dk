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

// Assert for internal errors, similar to assert but not removed in release builds
#define Assert(f)    do { \
                        if (!(f)) { \
                            cerr << "z88dk-z80asm panic at " << __FILE__ << ":" << __LINE__ << endl; \
                            exit(EXIT_FAILURE); \
                        } \
                    } while(0)

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

// read lines with any EOL terminator
istream& safe_getline(istream& is, string& t);

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
