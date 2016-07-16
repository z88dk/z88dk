////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "print_sequence.hpp"

namespace stlplus
{

  template<typename T, typename S>
  void print_vector(std::ostream& device, const std::vector<T>& values,
                               S print_fn,
                               const std::string& separator)
  {
    print_sequence(device, values.begin(), values.end(), print_fn, separator);
  }

} // end namespace stlplus
