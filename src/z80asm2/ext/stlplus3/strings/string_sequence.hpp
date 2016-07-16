#ifndef STLPLUS_STRING_SEQUENCE
#define STLPLUS_STRING_SEQUENCE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate string representations of sequences represented by forward iterators

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // any forward iterator sequence

  template <typename I, typename S>
  std::string sequence_to_string(I begin,
                                 I end, 
                                 S to_string,
                                 const std::string& separator);


  ////////////////////////////////////////////////////////////////////////////////
  // any forward iterator sequence of pairs

  template <typename I, typename S1, typename S2>
  std::string pair_sequence_to_string(I begin,
                                      I end,
                                      S1 to_string_fn1,
                                      S2 to_string_fn2,
                                      const std::string& pair_separator,
                                      const std::string& separator);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "string_sequence.tpp"
#endif
