#ifndef STLPLUS_STRING_FOURSOME
#define STLPLUS_STRING_FOURSOME
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

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T1, typename T2, typename T3, typename T4, typename S1, typename S2, typename S3, typename S4>
  std::string foursome_to_string(const foursome<T1,T2,T3,T4>& values,
                                 S1 to_string_fn1,
                                 S2 to_string_fn2,
                                 S3 to_string_fn3,
                                 S4 to_string_fn4,
                                 const std::string& separator = ":");

} // end namespace stlplus

#include "string_foursome.tpp"
#endif
