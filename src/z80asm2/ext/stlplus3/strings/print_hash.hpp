#ifndef STLPLUS_PRINT_HASH
#define STLPLUS_PRINT_HASH
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a hash

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "hash.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename K, typename T, typename H, typename E, typename KS, typename TS>
  void print_hash(std::ostream& device,
                  const hash<K,T,H,E>& values,
                  KS key_print_fn,
                  TS value_print_fn,
                  const std::string& pair_separator = ":",
                  const std::string& separator = ",");

} // end namespace stlplus

#include "print_hash.tpp"
#endif
