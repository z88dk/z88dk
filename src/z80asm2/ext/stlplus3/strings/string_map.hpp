#ifndef STLPLUS_STRING_MAP
#define STLPLUS_STRING_MAP
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a map/multimap

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <map>

namespace stlplus
{

  template<typename K, typename T, typename C, typename SK, typename ST>
  std::string map_to_string(const std::map<K,T,C>& values,
                            SK key_to_string_fn,
                            ST value_to_string_fn,
                            const std::string& pair_separator = ":",
                            const std::string& separator = ",");

  template<typename K, typename T, typename C, typename SK, typename ST>
  std::string multimap_to_string(const std::multimap<K,T,C>& values,
                                 SK key_to_string_fn,
                                 ST value_to_string_fn,
                                 const std::string& pair_separator = ":",
                                 const std::string& separator = ",");

} // end namespace stlplus

#include "string_map.tpp"
#endif
