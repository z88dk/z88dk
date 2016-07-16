#ifndef STLPLUS_PRINT_MAP
#define STLPLUS_PRINT_MAP
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a map/multimap

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>
#include <map>

namespace stlplus
{

  template<typename K, typename T, typename C, typename SK, typename ST>
  void print_map(std::ostream& device, const std::map<K,T,C>& values,
                 SK key_print_fn,
                 ST value_print_fn,
                 const std::string& pair_separator = ":",
                 const std::string& separator = ",");

  template<typename K, typename T, typename C, typename SK, typename ST>
  void print_multimap(std::ostream& device, const std::multimap<K,T,C>& values,
                      SK key_print_fn,
                      ST value_print_fn,
                      const std::string& pair_separator = ":",
                      const std::string& separator = ",");

} // end namespace stlplus

#include "print_map.tpp"
#endif
