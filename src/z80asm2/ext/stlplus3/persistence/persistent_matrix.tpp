////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename DT>
  void dump_matrix(dump_context& context, const matrix<T>& data,
                   DT dump_fn)
    throw(persistent_dump_failed)
  {
    unsigned rows = data.rows();
    unsigned cols = data.columns();
    dump_unsigned(context, rows);
    dump_unsigned(context, cols);
    for (unsigned r = 0; r < rows; r++)
      for (unsigned c = 0; c < cols; c++)
        dump_fn(context, data(r,c));
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename RT>
  void restore_matrix(restore_context& context, matrix<T>& data,
                      RT restore_fn)
    throw(persistent_restore_failed)
  {
    unsigned rows = 0;
    restore_unsigned(context, rows);
    unsigned cols = 0;
    restore_unsigned(context, cols);
    data.resize(rows,cols);
    for (unsigned r = 0; r < rows; r++)
      for (unsigned c = 0; c < cols; c++)
        restore_fn(context, data(r,c));
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
