#ifndef STLPLUS_PRINT_SIMPLE_PTR
#define STLPLUS_PRINT_SIMPLE_PTR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a smart pointer

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "simple_ptr.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_simple_ptr(std::ostream& device,
                       const simple_ptr<T>& value,
                       S print_fn,
                       const std::string& null_string = "<null>",
                       const std::string& prefix = "(",
                       const std::string& suffix = ")");

  template<typename T, typename S>
  void print_simple_ptr_clone(std::ostream& device,
                             const simple_ptr_clone<T>& value,
                             S print_fn,
                             const std::string& null_string = "<null>",
                             const std::string& prefix = "(",
                             const std::string& suffix = ")");

  template<typename T, typename S>
  void print_simple_ptr_nocopy(std::ostream& device,
                              const simple_ptr_nocopy<T>& value,
                              S print_fn,
                              const std::string& null_string = "<null>",
                              const std::string& prefix = "(",
                              const std::string& suffix = ")");


} // end namespace stlplus

#include "print_simple_ptr.tpp"
#endif
