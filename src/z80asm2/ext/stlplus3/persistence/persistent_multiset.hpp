#ifndef STLPLUS_PERSISTENT_MULTISET
#define STLPLUS_PERSISTENT_MULTISET
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STL multiset

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <set>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename K, typename P, typename D>
  void dump_multiset(dump_context&, const std::multiset<K,P>& data, D dump_fn)
    throw(persistent_dump_failed);

  template<typename K, typename P, typename R>
  void restore_multiset(restore_context&, std::multiset<K,P>& data, R restore_fn)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_multiset.tpp"
#endif
