////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "print_float.hpp"
#include "string_float.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // floating-point types

  void print_float(std::ostream& device, float f, real_display_t display, unsigned width, unsigned precision)
    throw(std::invalid_argument)
  {
    device << float_to_string(f, display, width, precision);
  }

  void print_double(std::ostream& device, double f, real_display_t display, unsigned width, unsigned precision)
    throw(std::invalid_argument)
  {
    device << double_to_string(f, display, width, precision);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
