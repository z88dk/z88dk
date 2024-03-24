//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

string str_chomp(const string& str);
string str_strip(const string& str);
string str_remove_extra_blanks(const string& str);
string str_remove_all_blanks(const string& str);
