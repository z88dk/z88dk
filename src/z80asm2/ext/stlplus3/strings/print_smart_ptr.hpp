#ifndef STLPLUS_PRINT_SMART_PTR
#define STLPLUS_PRINT_SMART_PTR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a smart pointer

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "smart_ptr.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_smart_ptr(std::ostream& device,
                       const smart_ptr<T>& value,
                       S print_fn,
                       const std::string& null_string = "<null>",
                       const std::string& prefix = "(",
                       const std::string& suffix = ")");

  template<typename T, typename S>
  void print_smart_ptr_clone(std::ostream& device,
                             const smart_ptr_clone<T>& value,
                             S print_fn,
                             const std::string& null_string = "<null>",
                             const std::string& prefix = "(",
                             const std::string& suffix = ")");

  template<typename T, typename S>
  void print_smart_ptr_nocopy(std::ostream& device,
                              const smart_ptr_nocopy<T>& value,
                              S print_fn,
                              const std::string& null_string = "<null>",
                              const std::string& prefix = "(",
                              const std::string& suffix = ")");


} // end namespace stlplus

#include "print_smart_ptr.tpp"
#endif
