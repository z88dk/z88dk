#ifndef STLPLUS_STRING_SET
#define STLPLUS_STRING_SET
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a set/multiset

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <set>

namespace stlplus
{

  template<typename K, typename C, typename S>
  std::string set_to_string(const std::set<K,C>& values,
                            S to_string_fn,
                            const std::string& separator = ",");

  template<typename K, typename C, typename S>
  std::string multiset_to_string(const std::multiset<K,C>& values,
                                 S to_string_fn,
                                 const std::string& separator = ",");

} // end namespace stlplus

#include "string_set.tpp"
#endif
