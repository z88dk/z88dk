#ifndef STLPLUS_STRING_LIST
#define STLPLUS_STRING_LIST
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a list

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <list>

namespace stlplus
{

  template<typename T, typename S>
  std::string list_to_string(const std::list<T>& values,
                             S to_string_fn,
                             const std::string& separator = ",");

} // end namespace stlplus

#include "string_list.tpp"
#endif
