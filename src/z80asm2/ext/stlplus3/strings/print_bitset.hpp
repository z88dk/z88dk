#ifndef STLPLUS_PRINT_BITSET
#define STLPLUS_PRINT_BITSET
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a bitset

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <bitset>
#include <string>
#include <iostream>

namespace stlplus
{

  template<size_t N>
  void print_bitset(std::ostream& device, const std::bitset<N>& data);

} // end namespace stlplus

#include "print_bitset.tpp"
#endif
