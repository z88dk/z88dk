////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  std::string simple_ptr_to_string(const simple_ptr<T>& value,
                                  S to_string_fn,
                                  const std::string& null_string,
                                  const std::string& prefix,
                                  const std::string& suffix)
  {
    return value ? (prefix + to_string_fn(*value) + suffix) : null_string;
  }

  template<typename T, typename S>
  std::string simple_ptr_clone_to_string(const simple_ptr_clone<T>& value,
                                        S to_string_fn,
                                        const std::string& null_string,
                                        const std::string& prefix,
                                        const std::string& suffix)
  {
    return value ? (prefix + to_string_fn(*value) + suffix) : null_string;
  }

  template<typename T, typename S>
  std::string simple_ptr_nocopy_to_string(const simple_ptr_nocopy<T>& value,
                                         S to_string_fn,
                                         const std::string& null_string,
                                         const std::string& prefix,
                                         const std::string& suffix)
  {
    return value ? (prefix + to_string_fn(*value) + suffix) : null_string;
  }

} // end namespace stlplus

