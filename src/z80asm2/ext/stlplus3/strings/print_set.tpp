////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   template implementations

////////////////////////////////////////////////////////////////////////////////
#include "print_sequence.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // set

  template<typename K, typename C, typename S>
  void print_set(std::ostream& device,
                 const std::set<K,C>& values,
                 S print_fn,
                 const std::string& separator)
  {
    print_sequence(device, values.begin(), values.end(), print_fn, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // multiset

  template<typename K, typename C, typename S>
  void print_multiset(std::ostream& device,
                      const std::multiset<K,C>& values,
                      S print_fn,
                      const std::string& separator)
  {
    print_sequence(device, values.begin(), values.end(), print_fn, separator);
  }

  ////////////////////////////////////////////////////////////////////////////////
} // end namespace stlplus
