////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename S>
  std::string matrix_to_string(const matrix<T>& values,
                               S to_string_fn,
                               const std::string& column_separator,
                               const std::string& row_separator)
  {
    std::string result;
    for (unsigned r = 0; r < values.rows(); r++)
    {
      if (r != 0) result += row_separator;
      for (unsigned c = 0; c < values.columns(); c++)
      {
        if (c != 0) result += column_separator;
        result += to_string_fn(values(r,c));
      }
    }
    return result;
  }

} // end namespace stlplus

