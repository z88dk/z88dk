////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  std::string ntree_to_string(const ntree<T>& values,
                              S to_string_fn,
                              const std::string& separator,
                              const std::string& indent_string)
  {
    std::string result;
    for (TYPENAME ntree<T>::const_prefix_iterator i = values.prefix_begin(); i != values.prefix_end(); i++)
    {
      if (i != values.prefix_begin()) result += separator;
      for (unsigned indent = values.depth(i.simplify()); --indent; )
        result += indent_string;
      result += to_string_fn(*i);
    }
    return result;
  }

} // end namespace stlplus

