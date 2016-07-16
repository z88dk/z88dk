#ifndef STLPLUS_PRINT_VECTOR
#define STLPLUS_PRINT_VECTOR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a vector

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>
#include <vector>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // vector

  template<typename T, typename S>
  void print_vector(std::ostream& device,
                    const std::vector<T>& values,
                    S print_fn,
                    const std::string& separator);

  // specialisation for vector<bool> which has a different implementation
  void print_bool_vector(std::ostream& device, const std::vector<bool>& values);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "print_vector.tpp"
#endif
