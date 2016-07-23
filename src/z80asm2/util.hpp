//-----------------------------------------------------------------------------
// Utility functions
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef UTIL_HPP
#define UTIL_HPP

#include <iostream>
#include <fstream>
#include <string>

// getline function that handles all three line endings ("\r", "\n" and "\r\n"):
// http://stackoverflow.com/questions/6089231/getting-std-ifstream-to-handle-lf-cr-and-crlf
extern std::istream& safeGetline(std::istream& is, std::string& t);

#endif /* ndef UTIL_HPP */
