#ifndef STLPLUS_STRING_POINTER
#define STLPLUS_STRING_POINTER
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of an object pointed to

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>

namespace stlplus
{

  template <typename T, typename S>
  std::string pointer_to_string(const T* value,
                                S to_string_fn,
                                const std::string& null_string = "<null>",
                                const std::string& prefix = "(",
                                const std::string& suffix = ")");


}

#include "string_pointer.tpp"
#endif
