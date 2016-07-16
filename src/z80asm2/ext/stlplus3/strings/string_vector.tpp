////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_sequence.hpp"

namespace stlplus
{

  template<typename T, typename S>
  std::string vector_to_string(const std::vector<T>& values,
                               S to_string_fn,
                               const std::string& separator)
  {
    return sequence_to_string(values.begin(), values.end(), to_string_fn, separator);
  }

} // end namespace stlplus
