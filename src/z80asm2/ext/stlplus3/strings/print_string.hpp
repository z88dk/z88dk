#ifndef STLPLUS_PRINT_STRING
#define STLPLUS_PRINT_STRING
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Functions for converting C/STL strings to string

//   This is necessary for completeness, e.g. for use in print_vector for vector<string>

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>
#include <stdexcept>

namespace stlplus
{

  void print_string(std::ostream& device, const std::string& value);
}

#endif
