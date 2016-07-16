#ifndef STLPLUS_PRINT_POINTER
#define STLPLUS_PRINT_POINTER
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of an object pointed to

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>

namespace stlplus
{

  template <typename T, typename S>
  void print_pointer(std::ostream& device,
                     const T* value,
                     S print_fn,
                     const std::string& null_string = "<null>",
                     const std::string& prefix = "(",
                     const std::string& suffix = ")");


}

#include "print_pointer.tpp"
#endif
