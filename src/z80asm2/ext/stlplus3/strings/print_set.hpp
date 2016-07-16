#ifndef STLPLUS_PRINT_SET
#define STLPLUS_PRINT_SET
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a set/multiset

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>
#include <set>

namespace stlplus
{

  template<typename K, typename C, typename S>
  void print_set(std::ostream& device,
                 const std::set<K,C>& values,
                 S print_fn,
                 const std::string& separator = ",");

  template<typename K, typename C, typename S>
  void print_multiset(std::ostream& device,
                      const std::multiset<K,C>& values,
                      S print_fn,
                      const std::string& separator = ",");

} // end namespace stlplus

#include "print_set.tpp"
#endif
