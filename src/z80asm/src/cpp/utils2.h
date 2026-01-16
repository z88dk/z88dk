//-----------------------------------------------------------------------------
// z80asm
// utils
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "if.h"
#include "utils.h"
#include <iostream>
#include <iomanip> 
#include <sstream>
#include <string>
#include <vector>
using namespace std;


// convert C-escape sequences
string str_compress_escapes(const string& in);
string str_expand_escapes(const string& in);

vector<string> split(const string& s);

// integer power function
int ipow(int base, int exp);

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
