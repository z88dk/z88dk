#ifndef STLPLUS_PRINT_FLOAT
#define STLPLUS_PRINT_FLOAT
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Convert a float/double to/from string

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "format_types.hpp"
#include <string>
#include <iostream>
#include <stdexcept>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // convert a real type to string
  ////////////////////////////////////////////////////////////////////////////////

  // Only decimal radix is supported

  // The way in which the number is displayed is defined in radix_types.hpp
  // Using any other value for the display type causes std::invalid_argument to be thrown

  void print_float(std::ostream& device, float f,
                   real_display_t display = display_mixed,
                   unsigned width = 0,
                   unsigned precision = 6)
    throw(std::invalid_argument);

  void print_double(std::ostream& device, double f,
                    real_display_t display = display_mixed,
                    unsigned width = 0,
                    unsigned precision = 6)
    throw(std::invalid_argument);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
