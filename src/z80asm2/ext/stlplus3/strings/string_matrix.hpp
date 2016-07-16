#ifndef STLPLUS_STRING_MATRIX
#define STLPLUS_STRING_MATRIX
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a matrix

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "matrix.hpp"
#include <string>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  std::string matrix_to_string(const matrix<T>& values,
                               S to_string_fn,
                               const std::string& column_separator = "|",
                               const std::string& row_separator = ",");

} // end namespace stlplus

#include "string_matrix.tpp"
#endif
