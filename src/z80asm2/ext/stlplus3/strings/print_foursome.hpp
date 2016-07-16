#ifndef STLPLUS_PRINT_FOURSOME
#define STLPLUS_PRINT_FOURSOME
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a foursome

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "foursome.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T1, typename T2, typename T3, typename T4, typename S1, typename S2, typename S3, typename S4>
  void print_foursome(std::ostream& device,
                      const foursome<T1,T2,T3,T4>& values,
                      S1 print_fn1,
                      S2 print_fn2,
                      S3 print_fn3,
                      S4 print_fn4,
                      const std::string& separator = ":");

} // end namespace stlplus

#include "print_foursome.tpp"
#endif
