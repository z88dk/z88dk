//-----------------------------------------------------------------------------
// z80asm - utilities
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <iostream>
using namespace std;

bool is_ident_start(char c);
bool is_ident(char c);
bool is_ident(const string& ident);
int char_digit(char c);

bool str_ends_with(const string& str, const string& ending);
string str_tolower(string str);
string str_toupper(string str);
string str_chomp(const string& str);
string str_strip(const string& str);
string str_remove_extra_blanks(const string& str);
string str_remove_all_blanks(const string& str);

istream& safe_getline(istream& is, string& t);
