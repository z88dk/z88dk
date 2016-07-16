#ifndef STLPLUS_PERSISTENT_HASH
#define STLPLUS_PERSISTENT_HASH
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence for STLplus hash

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include "hash.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename K, typename T, typename H, typename E, typename DK, typename DT>
  void dump_hash(dump_context&, const hash<K,T,H,E>& data, DK key_dump_fn, DT val_dump_fn)
    throw(persistent_dump_failed);

  template<typename K, typename T, typename H, typename E, typename RK, typename RT>
  void restore_hash(restore_context&, hash<K,T,H,E>& data, RK key_restore_fn, RT val_restore_fn)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_hash.tpp"
#endif
