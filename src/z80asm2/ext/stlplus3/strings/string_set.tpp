////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   template implementations

////////////////////////////////////////////////////////////////////////////////
#include "string_sequence.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // set

  template<typename K, typename C, typename S>
  std::string set_to_string(const std::set<K,C>& values,
                            S to_string_fn,
                            const std::string& separator)
  {
    return sequence_to_string(values.begin(), values.end(), to_string_fn, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // multiset

  template<typename K, typename C, typename S>
  std::string multiset_to_string(const std::multiset<K,C>& values,
                                 S to_string_fn,
                                 const std::string& separator)
  {
    return sequence_to_string(values.begin(), values.end(), to_string_fn, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
} // end namespace stlplus
