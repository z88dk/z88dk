#ifndef STLPLUS_PRINT_TRIPLE
#define STLPLUS_PRINT_TRIPLE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a triple

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "triple.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T1, typename T2, typename T3, typename S1, typename S2, typename S3>
  void print_triple(std::ostream& device,
                    const triple<T1,T2,T3>& values,
                    S1 print_fn1,
                    S2 print_fn2,
                    S3 print_fn3,
                    const std::string& separator = ":");

} // end namespace stlplus

#include "print_triple.tpp"
#endif
