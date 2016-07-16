////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<size_t N>
  std::string bitset_to_string(const std::bitset<N>& data)
  {
    std::string result;
    for (size_t i = data.size(); i--; )
      result += data.test(i) ? '1' : '0';
    return result;
  }

} // end namespace stlplus
