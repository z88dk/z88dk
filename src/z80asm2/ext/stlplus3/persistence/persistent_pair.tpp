////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_pair.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename K, typename T, typename D1, typename D2>
  void dump_pair(dump_context& context, const std::pair<K,T>& data, D1 dump_fn1, D2 dump_fn2)
    throw(persistent_dump_failed)
  {
    dump_fn1(context,data.first);
    dump_fn2(context,data.second);
  }

  template<typename K, typename T, typename R1, typename R2>
  void restore_pair(restore_context& context, std::pair<K,T>& data, R1 restore_fn1, R2 restore_fn2)
    throw(persistent_restore_failed)
  {
    restore_fn1(context,data.first);
    restore_fn2(context,data.second);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
