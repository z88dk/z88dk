////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_sequence.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // map

  template<typename K, typename T, typename C, typename SK, typename ST>
  std::string map_to_string(const std::map<K,T,C>& values,
                            SK key_to_string_fn,
                            ST value_to_string_fn,
                            const std::string& pair_separator,
                            const std::string& separator)
  {
    return pair_sequence_to_string(values.begin(), values.end(),
                                   key_to_string_fn, value_to_string_fn,
                                   pair_separator, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // multimap

  template<typename K, typename T, typename C, typename SK, typename ST>
  std::string multimap_to_string(const std::multimap<K,T,C>& values,
                                 SK key_to_string_fn,
                                 ST value_to_string_fn,
                                 const std::string& pair_separator,
                                 const std::string& separator)
  {
    return pair_sequence_to_string(values.begin(), values.end(),
                                   key_to_string_fn, value_to_string_fn,
                                   pair_separator, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
} // end namespace stlplus
