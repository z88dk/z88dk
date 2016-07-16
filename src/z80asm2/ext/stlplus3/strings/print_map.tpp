////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "print_sequence.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // map

  template<typename K, typename T, typename C, typename SK, typename ST>
  void print_map(std::ostream& device, const std::map<K,T,C>& values,
                 SK key_print_fn,
                 ST value_print_fn,
                 const std::string& pair_separator,
                 const std::string& separator)
  {
    print_pair_sequence(device,
                        values.begin(), values.end(),
                        key_print_fn, value_print_fn,
                        pair_separator, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // multimap

  template<typename K, typename T, typename C, typename SK, typename ST>
  void print_multimap(std::ostream& device, const std::multimap<K,T,C>& values,
                      SK key_print_fn,
                      ST value_print_fn,
                      const std::string& pair_separator,
                      const std::string& separator)
  {
    print_pair_sequence(device,
                        values.begin(), values.end(),
                        key_print_fn, value_print_fn,
                        pair_separator, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
} // end namespace stlplus
