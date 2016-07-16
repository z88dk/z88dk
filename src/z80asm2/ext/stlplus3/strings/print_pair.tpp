////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename V1, typename V2, typename S1, typename S2>
  void print_pair(std::ostream& device,
                  const std::pair<V1,V2>& values,
                  S1 print_fn1,
                  S2 print_fn2,
                  const std::string& separator)
  {
    print_fn1(device, values.first);
    device << separator;
    print_fn2(device, values.second);
  }

} // end namespace stlplus
