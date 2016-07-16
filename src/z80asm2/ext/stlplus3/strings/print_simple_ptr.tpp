////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_simple_ptr(std::ostream& device,
                       const simple_ptr<T>& value,
                       S print_fn,
                       const std::string& null_string,
                       const std::string& prefix,
                       const std::string& suffix)
  {
    if (value)
    {
      device << prefix;
      print_fn(device, *value);
      device << suffix;
    }
    else
    {
      device << null_string;
    }
  }

  template<typename T, typename S>
  void print_simple_ptr_clone(std::ostream& device,
                             const simple_ptr_clone<T>& value,
                             S print_fn,
                             const std::string& null_string,
                             const std::string& prefix,
                             const std::string& suffix)
  {
    if (value)
    {
      device << prefix;
      print_fn(device, *value);
      device << suffix;
    }
    else
    {
      device << null_string;
    }
  }

  template<typename T, typename S>
  void print_simple_ptr_nocopy(std::ostream& device,
                              const simple_ptr_nocopy<T>& value,
                              S print_fn,
                              const std::string& null_string,
                              const std::string& prefix,
                              const std::string& suffix)
  {
    if (value)
    {
      device << prefix;
      print_fn(device, *value);
      device << suffix;
    }
    else
    {
      device << null_string;
    }
  }

} // end namespace stlplus

