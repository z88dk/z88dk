////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   use the unsigned short representation for bool

////////////////////////////////////////////////////////////////////////////////
#include "string_bool.hpp"
#include "string_int.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  std::string bool_to_string(bool i, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    return unsigned_short_to_string((unsigned short)i, radix, display, width);
  }

  ////////////////////////////////////////////////////////////////////////////////

  bool string_to_bool(const std::string& str, unsigned radix)
    throw(std::invalid_argument)
  {
    return string_to_unsigned_short(str, radix) != 0;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
