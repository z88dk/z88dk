////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include <string>

namespace stlplus
{

  template <typename T, typename S>
  std::string pointer_to_string(const T* value,
                                S to_string_fn,
                                const std::string& null_string,
                                const std::string& prefix,
                                const std::string& suffix)
  {
    return value ? (prefix + to_string_fn(*value) + suffix) : null_string;
  }

} // end namespace stlplus
