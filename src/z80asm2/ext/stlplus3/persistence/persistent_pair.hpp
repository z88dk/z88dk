#ifndef STLPLUS_PERSISTENT_PAIR
#define STLPLUS_PERSISTENT_PAIR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STL pair

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <map>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename V1, typename V2, typename D1, typename D2>
  void dump_pair(dump_context&, const std::pair<V1,V2>& data, D1 dump_fn1, D2 dump_fn2)
    throw(persistent_dump_failed);

  template<typename V1, typename V2, typename R1, typename R2>
  void restore_pair(restore_context&, std::pair<V1,V2>& data, R1 restore_fn1, R2 restore_fn2)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_pair.tpp"
#endif
