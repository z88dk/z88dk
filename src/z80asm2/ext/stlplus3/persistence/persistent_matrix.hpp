#ifndef STLPLUS_PERSISTENT_MATRIX
#define STLPLUS_PERSISTENT_MATRIX
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STLplus matrix

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include "matrix.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename DT>
  void dump_matrix(dump_context&, const matrix<T>& data, DT dump_fn)
    throw(persistent_dump_failed);

  template<typename T, typename RT>
  void restore_matrix(restore_context&, matrix<T>& data, RT restore_fn)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_matrix.tpp"
#endif
