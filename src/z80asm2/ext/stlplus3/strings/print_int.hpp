#ifndef STLPLUS_PRINT_INT
#define STLPLUS_PRINT_INT
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Print integer types

//   This extends the formatting available from iostream

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "format_types.hpp"
#include <iostream>
#include <stdexcept>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Conversions of Integer types to string
  ////////////////////////////////////////////////////////////////////////////////

  // The radix (i.e. base) for these conversions can be any value from base 2 to base 36
  // specifying any other radix causes std::invalid_argument to be thrown

  // The way in which the radix is displayed is defined in radix_types.hpp
  // If any other value is used, std::invalid_argument is thrown

  // The width argument specifies the number of numerical digits to use in the result
  // This is a minimum - if the value requires more digits then it will be wider than the width argument
  // However, if it is smaller, then it will be extended to the specified width
  // Then, the radix display prefix is added to this width

  // For example, using the hash representation of 0 in hex with width=4 gives:
  // 16#0000 - so there's 4 digits in the number part

  void print_short(std::ostream& device, short i,
                   unsigned radix = 10,
                   radix_display_t display = radix_c_style_or_hash,
                   unsigned width = 0)
    throw(std::invalid_argument);

  void print_unsigned_short(std::ostream& device, unsigned short i,
                            unsigned radix = 10,
                            radix_display_t display = radix_c_style_or_hash,
                            unsigned width = 0)
    throw(std::invalid_argument);

  void print_int(std::ostream& device, int i,
                 unsigned radix = 10,
                 radix_display_t display = radix_c_style_or_hash,
                 unsigned width = 0)
    throw(std::invalid_argument);

  void print_unsigned(std::ostream& device, unsigned i,
                      unsigned radix = 10,
                      radix_display_t display = radix_c_style_or_hash,
                      unsigned width = 0)
    throw(std::invalid_argument);

  void print_long(std::ostream& device, long i,
                  unsigned radix = 10,
                  radix_display_t display = radix_c_style_or_hash,
                  unsigned width = 0)
    throw(std::invalid_argument);

  void print_unsigned_long(std::ostream& device, unsigned long i,
                           unsigned radix = 10,
                           radix_display_t display = radix_c_style_or_hash,
                           unsigned width = 0)
    throw(std::invalid_argument);

#ifdef CXX11
  void print_longlong(std::ostream& device, long long i,
                      unsigned radix = 10,
                      radix_display_t display = radix_c_style_or_hash,
                      unsigned width = 0)
    throw(std::invalid_argument);

  void print_unsigned_longlong(std::ostream& device, unsigned long long i,
                               unsigned radix = 10,
                               radix_display_t display = radix_c_style_or_hash,
                               unsigned width = 0)
    throw(std::invalid_argument);
#endif

  ////////////////////////////////////////////////////////////////////////////////

  void print_address(std::ostream& device, const void*,
                     unsigned radix = 16,
                     radix_display_t display = radix_c_style_or_hash,
                     unsigned width = 0)
    throw(std::invalid_argument);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
