//-----------------------------------------------------------------------------
// z80asm
// utils
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

// std::filesystem from C++17
#include <filesystem>
namespace fs = std::filesystem;

// change case
string str_tolower(string str);
string str_toupper(string str);

// convert C-escape sequences
string str_compress_escapes(const string& in);

// check string ending
bool str_ends_with(const string& str, const string& ending);

// read lines with any EOL terminator
istream& safe_getline(istream& is, string& t);
