#ifndef STLPLUS_PRINT_MATRIX
#define STLPLUS_PRINT_MATRIX
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
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_matrix(std::ostream& device,
                    const matrix<T>& values,
                    S print_fn,
                    const std::string& column_separator = "|",
                    const std::string& row_separator = ",");

} // end namespace stlplus

#include "print_matrix.tpp"
#endif
