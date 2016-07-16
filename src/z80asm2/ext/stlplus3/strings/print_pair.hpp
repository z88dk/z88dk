#ifndef STLPLUS_PRINT_PAIR
#define STLPLUS_PRINT_PAIR
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
#include <iostream>

namespace stlplus
{

  template<typename V1, typename V2, typename S1, typename S2>
  void print_pair(std::ostream& device,
                  const std::pair<V1,V2>& values,
                  S1 print_fn1,
                  S2 print_fn2,
                  const std::string& separator = ":");

} // end namespace stlplus

#include "print_pair.tpp"
#endif
