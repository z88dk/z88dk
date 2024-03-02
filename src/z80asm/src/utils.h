//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

string str_strip(const string& str);				// remove start and end blanks
string str_chomp(const string& str);				// remove end blanks
string str_remove_all_blanks(const string& str);	// remove all blanks
string str_remove_extra_blanks(const string& str);	// replace sequences of blanks with one space
