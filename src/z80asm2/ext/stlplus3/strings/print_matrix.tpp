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
  void print_matrix(std::ostream& device, const matrix<T>& values,
                    S print_fn,
                    const std::string& column_separator,
                    const std::string& row_separator)
  {
    for (unsigned r = 0; r < values.rows(); r++)
    {
      if (r != 0) device << row_separator;
      for (unsigned c = 0; c < values.columns(); c++)
      {
        if (c != 0) device << column_separator;
        print_fn(device, values(r,c));
      }
    }
  }

} // end namespace stlplus

