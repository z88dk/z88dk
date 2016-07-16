#ifndef STLPLUS_STRING_HASH
#define STLPLUS_STRING_HASH
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

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename K, typename T, typename H, typename E, typename KS, typename TS>
  std::string hash_to_string(const hash<K,T,H,E>& values,
                             KS key_to_string_fn,
                             TS value_to_string_fn,
                             const std::string& pair_separator = ":",
                             const std::string& separator = ",");

} // end namespace stlplus

#include "string_hash.tpp"
#endif
