////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_sequence.hpp"

namespace stlplus
{

  template<typename K, typename T, typename H, typename E, typename KS, typename TS>
  std::string hash_to_string(const hash<K,T,H,E>& values,
                             KS key_to_string_fn,
                             TS value_to_string_fn,
                             const std::string& pair_separator,
                             const std::string& separator)
  {
    return pair_sequence_to_string(values.begin(), values.end(),
                                   key_to_string_fn, value_to_string_fn,
                                   pair_separator, separator);
  }

} // end namespace stlplus

