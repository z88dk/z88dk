////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "print_pair.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // any forward iterator sequence

  template <typename I, typename S>
  void print_sequence(std::ostream& device,
                      I begin, I end, 
                      S print_fn,
                      const std::string& separator)
  {
    for (I i = begin; i != end; i++)
    {
      if (i != begin) device << separator;
      print_fn(device, *i);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
  // any sequence where the value is a pair

  template <typename I, typename S1, typename S2>
  void print_pair_sequence(std::ostream& device,
                           I begin, I end,
                           S1 print_fn1,
                           S2 print_fn2,
                           const std::string& pair_separator,
                           const std::string& separator)
  {
    for (I i = begin; i != end; i++)
    {
      if (i != begin) device << separator;
      print_pair(device, *i, print_fn1, print_fn2, pair_separator);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
