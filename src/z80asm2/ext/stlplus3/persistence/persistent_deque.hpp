#ifndef STLPLUS_PERSISTENT_DEQUE
#define STLPLUS_PERSISTENT_DEQUE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of the STL deque

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <deque>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename D>
  void dump_deque(dump_context&, const std::deque<T>& data, D dump_fn) throw(persistent_dump_failed);

  template<typename T, typename R>
  void restore_deque(restore_context&, std::deque<T>& data, R restore_fn) throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_deque.tpp"
#endif
