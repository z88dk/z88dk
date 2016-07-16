#ifndef STLPLUS_PRINT_SEQUENCE
#define STLPLUS_PRINT_SEQUENCE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate string representations of sequences represented by forward iterators

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include <string>
#include <iostream>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // any forward iterator sequence

  template <typename I, typename S>
  void print_sequence(std::ostream& device,
                      I begin, I end, 
                      S print_fn,
                      const std::string& separator);


  ////////////////////////////////////////////////////////////////////////////////
  // any forward iterator sequence of pairs

  template <typename I, typename S1, typename S2>
  void print_pair_sequence(std::ostream& device,
                           I begin, I end,
                           S1 print_fn1,
                           S2 print_fn2,
                           const std::string& pair_separator,
                           const std::string& separator);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "print_sequence.tpp"
#endif
