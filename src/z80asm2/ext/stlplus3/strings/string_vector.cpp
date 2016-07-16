////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_vector.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // special case of vector<bool>

  std::string bool_vector_to_string(const std::vector<bool>& values)
  {
    std::string result;
    for (size_t i = 0; i < values.size(); i++)
      result.append(1, values[i] ? '1' : '0');
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
