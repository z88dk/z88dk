#ifndef STLPLUS_STRING_SIMPLE_PTR
#define STLPLUS_STRING_SIMPLE_PTR
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

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  std::string simple_ptr_to_string(const simple_ptr<T>& value,
                                  S to_string_fn,
                                  const std::string& null_string = "<null>",
                                  const std::string& prefix = "(",
                                  const std::string& suffix = ")");

  template<typename T, typename S>
  std::string simple_ptr_clone_to_string(const simple_ptr_clone<T>& value,
                                        S to_string_fn,
                                        const std::string& null_string = "<null>",
                                        const std::string& prefix = "(",
                                        const std::string& suffix = ")");

  template<typename T, typename S>
  std::string simple_ptr__nocopy_to_string(const simple_ptr_nocopy<T>& value,
                                          S to_string_fn,
                                          const std::string& null_string = "<null>",
                                          const std::string& prefix = "(",
                                          const std::string& suffix = ")");


} // end namespace stlplus

#include "string_simple_ptr.tpp"
#endif
