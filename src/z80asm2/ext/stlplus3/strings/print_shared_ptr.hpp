#ifndef STLPLUS_PRINT_SHARED_PTR
#define STLPLUS_PRINT_SHARED_PTR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a shared pointer

////////////////////////////////////////////////////////////////////////////////

#include "strings_fixes.hpp"
#include <memory>
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_shared_ptr(std::ostream& device,
                        const std::shared_ptr<T>& value,
                        S print_fn,
                        const std::string& empty_string = "<empty>",
                        const std::string& null_string = "<null>",
                        const std::string& prefix = "(",
                        const std::string& suffix = ")");

} // end namespace stlplus

#include "print_shared_ptr.tpp"
#endif
