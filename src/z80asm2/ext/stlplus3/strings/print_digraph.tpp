////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "print_sequence.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename NT, typename AT, typename NS, typename AS>
  void print_digraph(std::ostream& device, const digraph<NT,AT>& values,
                     NS node_print_fn,
                     AS arc_print_fn,
                     const std::string& separator)
  {
    device << "nodes:";
    device << separator;
    print_sequence(device, values.begin(), values.end(), node_print_fn, separator);
    device << "arcs:";
    device << separator;
    print_sequence(device, values.arc_begin(), values.arc_end(), arc_print_fn, separator);
  }

} // end namespace stlplus

