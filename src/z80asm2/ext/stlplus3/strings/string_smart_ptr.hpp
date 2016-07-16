#ifndef STLPLUS_STRING_SMART_PTR
#define STLPLUS_STRING_SMART_PTR
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

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  std::string smart_ptr_to_string(const smart_ptr<T>& value,
                                  S to_string_fn,
                                  const std::string& null_string = "<null>",
                                  const std::string& prefix = "(",
                                  const std::string& suffix = ")");

  template<typename T, typename S>
  std::string smart_ptr_clone_to_string(const smart_ptr_clone<T>& value,
                                        S to_string_fn,
                                        const std::string& null_string = "<null>",
                                        const std::string& prefix = "(",
                                        const std::string& suffix = ")");

  template<typename T, typename S>
  std::string smart_ptr__nocopy_to_string(const smart_ptr_nocopy<T>& value,
                                          S to_string_fn,
                                          const std::string& null_string = "<null>",
                                          const std::string& prefix = "(",
                                          const std::string& suffix = ")");


} // end namespace stlplus

#include "string_smart_ptr.tpp"
#endif
