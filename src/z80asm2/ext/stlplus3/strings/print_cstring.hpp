#ifndef STLPLUS_PRINT_CSTRING
#define STLPLUS_PRINT_CSTRING
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Functions for converting C/STL strings to string

//   This is necessary for completeness

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>
#include <stdexcept>

namespace stlplus
{

  void print_cstring(std::ostream& device, const char* value);

}

#endif
