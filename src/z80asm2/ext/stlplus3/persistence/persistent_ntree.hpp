#ifndef STLPLUS_PERSISTENT_NTREE
#define STLPLUS_PERSISTENT_NTREE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STLplus ntree

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include "ntree.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  // ntree

  template<typename T, typename D>
  void dump_ntree(dump_context&, const ntree<T>& data, D dump_fn)
    throw(persistent_dump_failed);

  template<typename T, typename R>
  void restore_ntree(restore_context&, ntree<T>& data, R restore_fn)
    throw(persistent_restore_failed);

  // iterator

  template<typename T, typename TRef, typename TPtr>
  void dump_ntree_iterator(dump_context&, const ntree_iterator<T,TRef,TPtr>&)
    throw(persistent_dump_failed);

  template<typename T, typename TRef, typename TPtr>
  void restore_ntree_iterator(restore_context&, ntree_iterator<T,TRef,TPtr>&)
    throw(persistent_restore_failed);

  // prefix iterator

  template<typename T, typename TRef, typename TPtr>
  void dump_ntree_prefix_iterator(dump_context&, const ntree_prefix_iterator<T,TRef,TPtr>&)
    throw(persistent_dump_failed);

  template<typename T, typename TRef, typename TPtr>
  void restore_ntree_prefix_iterator(restore_context&, ntree_prefix_iterator<T,TRef,TPtr>&)
    throw(persistent_restore_failed);

  // postfix iterator

  template<typename T, typename TRef, typename TPtr>
  void dump_ntree_postfix_iterator(dump_context&, const ntree_postfix_iterator<T,TRef,TPtr>&)
    throw(persistent_dump_failed);

  template<typename T, typename TRef, typename TPtr>
  void restore_ntree_postfix_iterator(restore_context&, ntree_postfix_iterator<T,TRef,TPtr>&)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_ntree.tpp"
#endif
