////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   use the unsigned short representation for bool

////////////////////////////////////////////////////////////////////////////////
#include "print_bool.hpp"
#include "print_int.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  void print_bool(std::ostream& device, bool i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    print_unsigned_short(device, (unsigned short)i, radix, display, width);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
