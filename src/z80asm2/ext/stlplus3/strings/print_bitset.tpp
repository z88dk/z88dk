////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_bitset.hpp"

namespace stlplus
{

  template<size_t N>
  void print_bitset(std::ostream& device, const std::bitset<N>& data)
  {
    device << bitset_to_string(data);
  }

} // end namespace stlplus
