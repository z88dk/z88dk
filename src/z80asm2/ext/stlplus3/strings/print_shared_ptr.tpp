////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename S>
  void print_shared_ptr(std::ostream& device,
                        const std::shared_ptr<T>& value,
                        S print_fn,
                        const std::string& empty_string,
                        const std::string& null_string,
                        const std::string& prefix,
                        const std::string& suffix)
  {
    if (value.use_count() == 0)
      device << empty_string;
    else if (value.get() == 0)
      device << null_string;
    else
    {
      device << prefix;
      print_fn(device, *value);
      device << suffix;
    }
  }

} // end namespace stlplus

