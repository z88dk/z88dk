////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_cstring.hpp"

namespace stlplus
{

  std::string cstring_to_string(const char* value)
  {
    return std::string(value);
  }

} // end namespace stlplus
