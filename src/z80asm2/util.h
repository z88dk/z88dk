//-----------------------------------------------------------------------------
// z80asm - input
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <string>
#include <fstream>

// getline function that handles all three line endings ("\r", "\n" and "\r\n"):
// http://stackoverflow.com/questions/6089231/getting-std-ifstream-to-handle-lf-cr-and-crlf
extern std::istream& safeGetline(std::istream& is, std::string& t);

extern bool file_exists(const std::string& filename);
