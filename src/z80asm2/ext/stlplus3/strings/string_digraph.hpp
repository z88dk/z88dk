#ifndef STLPLUS_STRING_DIGRAPH
#define STLPLUS_STRING_DIGRAPH
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

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename NT, typename AT, typename NS, typename AS>
  std::string digraph_to_string(const digraph<NT,AT>& values,
                                NS node_to_string_fn,
                                AS arc_to_string_fn,
                                const std::string& separator = ",");

} // end namespace stlplus

#include "string_digraph.tpp"
#endif
