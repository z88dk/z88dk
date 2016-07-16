#ifndef STLPLUS_PERSISTENT_SET
#define STLPLUS_PERSISTENT_SET
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Set of persistence routines for the STL classes

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <set>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename K, typename P, typename D>
  void dump_set(dump_context&, const std::set<K,P>& data, D dump_fn)
    throw(persistent_dump_failed);

  template<typename K, typename P, typename R>
  void restore_set(restore_context&, std::set<K,P>& data, R restore_fn)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_set.tpp"
#endif
