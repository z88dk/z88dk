#ifndef STLPLUS_STRING_PAIR
#define STLPLUS_STRING_PAIR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a pair

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <map>
#include <string>

namespace stlplus
{

  template<typename V1, typename V2, typename S1, typename S2>
  std::string pair_to_string(const std::pair<V1,V2>& values,
                             S1 to_string_fn1,
                             S2 to_string_fn2,
                             const std::string& separator = ":");

} // end namespace stlplus

#include "string_pair.tpp"
#endif
