#ifndef STLPLUS_PORTABILITY_EXCEPTIONS
#define STLPLUS_PORTABILITY_EXCEPTIONS
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Adds missing arithmetic exceptions used in this library but missing from std

////////////////////////////////////////////////////////////////////////////////
#include "portability_fixes.hpp"
#include <string>
#include <stdexcept>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // thrown by division when the divisor is zero
  // This is a subclass of std::logic_error so can be caught by a generic catch clause for the superclass

  class divide_by_zero : public std::logic_error {
  public:
    divide_by_zero (const std::string& what_arg): std::logic_error (what_arg) { }
  };

////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
