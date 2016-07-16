#ifndef STLPLUS_STRING_BITSET
#define STLPLUS_STRING_BITSET
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

namespace stlplus
{

  template<size_t N>
  std::string bitset_to_string(const std::bitset<N>& data);

} // end namespace stlplus

#include "string_bitset.tpp"
#endif
