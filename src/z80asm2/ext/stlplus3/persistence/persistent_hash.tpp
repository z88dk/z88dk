////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename K, typename T, typename H, typename E, typename DK, typename DT>
  void dump_hash(dump_context& context, const hash<K,T,H,E>& data, DK key_fn, DT val_fn)
    throw(persistent_dump_failed)
  {
    dump_unsigned(context,data.size());
    for (typename hash<K,T,H,E>::const_iterator i = data.begin(); i != data.end(); i++)
    {
      key_fn(context,i->first);
      val_fn(context,i->second);
    }
  }

  template<typename K, typename T, typename H, typename E, typename RK, typename RT>
  void restore_hash(restore_context& context, hash<K,T,H,E>& data, RK key_fn, RT val_fn)
    throw(persistent_restore_failed)
  {
    data.erase();
    unsigned size = 0;
    restore_unsigned(context,size);
    for (unsigned j = 0; j < size; j++)
    {
      K key;
      key_fn(context,key);
      val_fn(context,data[key]);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
