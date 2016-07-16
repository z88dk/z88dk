#ifndef STLPLUS_PRINT_NTREE
#define STLPLUS_PRINT_NTREE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of an ntree

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "ntree.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_ntree(std::ostream& device,
                   const ntree<T>& values,
                   S print_fn,
                   const std::string& separator = "|",
                   const std::string& indent_string = "  ");

} // end namespace stlplus

#include "print_ntree.tpp"
#endif
