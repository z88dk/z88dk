////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "print_sequence.hpp"

namespace stlplus
{

  template<typename K, typename T, typename H, typename E, typename KS, typename TS>
  void print_hash(std::ostream& device,
                  const hash<K,T,H,E>& values,
                  KS key_print_fn,
                  TS value_print_fn,
                  const std::string& pair_separator,
                  const std::string& separator)
  {
    print_pair_sequence(device, 
                        values.begin(), values.end(),
                        key_print_fn, value_print_fn,
                        pair_separator, separator);
  }

} // end namespace stlplus

