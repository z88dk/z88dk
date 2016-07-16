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

  template<typename K, typename T, typename P, typename DK, typename DT>
  void dump_multimap(dump_context& context, const std::multimap<K,T,P>& data, DK key_fn, DT val_fn)
    throw(persistent_dump_failed)
  {
    dump_size_t(context,data.size());
    for (typename std::multimap<K,T,P>::const_iterator i = data.begin(); i != data.end(); i++)
    {
      key_fn(context,i->first);
      val_fn(context,i->second);
    }
  }

  template<typename K, typename T, typename P, typename RK, typename RT>
  void restore_multimap(restore_context& context, std::multimap<K,T,P>& data, RK key_fn, RT val_fn)
    throw(persistent_restore_failed)
  {
    data.clear();
    size_t size = 0;
    restore_size_t(context,size);
    for (size_t j = 0; j < size; j++)
    {
      K key;
      key_fn(context,key);
      typename std::multimap<K,T,P>::iterator v = data.insert(std::pair<K,T>(key,T()));
      val_fn(context,v->second);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
