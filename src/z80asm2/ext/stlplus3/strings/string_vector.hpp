#ifndef STLPLUS_STRING_VECTOR
#define STLPLUS_STRING_VECTOR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a vector

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <vector>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // vector

  template<typename T, typename S>
  std::string vector_to_string(const std::vector<T>& values,
                               S to_string_fn,
                               const std::string& separator = ",");

  // specialisation for vector<bool> which has a different implementation
  std::string bool_vector_to_string(const std::vector<bool>& values);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "string_vector.tpp"
#endif
