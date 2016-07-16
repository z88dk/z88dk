////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  std::string shared_ptr_to_string(const std::shared_ptr<T>& value,
                                   S to_string_fn,
                                   const std::string& empty_string,
                                   const std::string& null_string,
                                   const std::string& prefix,
                                   const std::string& suffix)
  {
    if (value.use_count() == 0)
      return empty_string;
    if (value.get() == 0)
      return null_string;
    return prefix + to_string_fn(*value) + suffix;
  }

} // end namespace stlplus

