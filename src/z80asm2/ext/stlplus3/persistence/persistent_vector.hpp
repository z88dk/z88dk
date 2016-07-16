#ifndef STLPLUS_PERSISTENT_VECTOR
#define STLPLUS_PERSISTENT_VECTOR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STL vector

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <vector>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  // vector

  template<typename T, typename D>
  void dump_vector(dump_context&, const std::vector<T>& data, D dump_fn)
    throw(persistent_dump_failed);

  template<typename T, typename R>
  void restore_vector(restore_context&, std::vector<T>& data, R restore_fn)
    throw(persistent_restore_failed);

  // specialism for vector<bool>

  void dump_vector_bool(dump_context&, const std::vector<bool>& data)
    throw(persistent_dump_failed);

  void restore_vector_bool(restore_context&, std::vector<bool>& data)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_vector.tpp"
#endif
