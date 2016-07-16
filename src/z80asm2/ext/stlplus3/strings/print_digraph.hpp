#ifndef STLPLUS_PRINT_DIGRAPH
#define STLPLUS_PRINT_DIGRAPH
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Generate a string representation of a digraph

////////////////////////////////////////////////////////////////////////////////
#include "strings_fixes.hpp"
#include "digraph.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename NT, typename AT, typename NS, typename AS>
  void print_digraph(std::ostream& device,
                     const digraph<NT,AT>& values,
                     NS node_print_fn,
                     AS arc_print_fn,
                     const std::string& separator = ",");

} // end namespace stlplus

#include "print_digraph.tpp"
#endif
