#ifndef STLPLUS_PERSISTENT_TRIPLE
#define STLPLUS_PERSISTENT_TRIPLE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STL triple

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include "triple.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T1, typename T2, typename T3, typename D1, typename D2, typename D3>
  void dump_triple(dump_context&, const stlplus::triple<T1,T2,T3>& data, 
                   D1 dump_fn1, D2 dump_fn2, D3 dump_fn3)
    throw(persistent_dump_failed);

  template<typename T1, typename T2, typename T3, typename R1, typename R2, typename R3>
  void restore_triple(restore_context&, stlplus::triple<T1,T2,T3>& data,
                      R1 restore_fn1, R2 restore_fn2, R3 restore_fn3)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_triple.tpp"
#endif
