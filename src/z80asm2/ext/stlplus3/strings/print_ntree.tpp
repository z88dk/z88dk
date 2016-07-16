////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_ntree(std::ostream& device,
                   const ntree<T>& values,
                   S print_fn,
                   const std::string& separator,
                   const std::string& indent_string)
  {
    for (TYPENAME ntree<T>::const_prefix_iterator i = values.prefix_begin(); i != values.prefix_end(); i++)
    {
      if (i != values.prefix_begin()) device << separator;
      for (unsigned indent = values.depth(i.simplify()); --indent; )
        device << indent_string;
      print_fn(device, *i);
    }
  }

} // end namespace stlplus

