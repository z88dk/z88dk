////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   format: magic_key [ data ]

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename D>
  void dump_pointer(dump_context& context, const T* const data, D dump_fn)
    throw(persistent_dump_failed)
  {
    // register the address and get the magic key for it
    std::pair<bool,unsigned> mapping = context.pointer_map(data);
    dump_unsigned(context,mapping.second);
    // if the address is null, then that is all that we need to do
    // however, if it is non-null and this is the first sight of the address, dump the contents
    // note that the address is mapped before it is dumped so that self-referential structures dump correctly
    if (data && !mapping.first)
      dump_fn(context,*data);
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename R>
  void restore_pointer(restore_context& context, T*& data, R restore_fn)
    throw(persistent_restore_failed)
  {
    if (data)
    {
      delete data;
      data = 0;
    }
    // get the magic key
    unsigned magic = 0;
    restore_unsigned(context,magic);
    // now lookup the magic key to see if this pointer has already been restored
    // null pointers are always flagged as already restored
    std::pair<bool,void*> address = context.pointer_map(magic);
    if (address.first)
    {
      // seen before, so simply assign the old address
      data = (T*)address.second;
    }
    else
    {
      // this pointer has never been seen before and is non-null
      data = new T();
      // add this pointer to the set of already seen objects
      // do this before restoring the object so that self-referential structures restore correctly
      context.pointer_add(magic,data);
      // now restore it
      restore_fn(context,*data);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
