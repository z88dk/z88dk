////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_sequence.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename NT, typename AT, typename NS, typename AS>
  std::string digraph_to_string(const digraph<NT,AT>& values,
                                NS node_to_string_fn,
                                AS arc_to_string_fn,
                                const std::string& separator)
  {
    std::string result;
    result += "nodes:";
    result += separator;
    result += sequence_to_string(values.begin(), values.end(), node_to_string_fn, separator);
    result += "arcs:";
    result += separator;
    result += sequence_to_string(values.arc_begin(), values.arc_end(), arc_to_string_fn, separator);
    return result;
  }

} // end namespace stlplus

