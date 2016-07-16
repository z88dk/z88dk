////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Polymorphous classes using the interface approach

//   format: magic [ key data ]

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T>
  void dump_interface(dump_context& context, const T* const data)
    throw(persistent_dump_failed)
  {
    try
    {
      // register the address and get the magic key for it
      std::pair<bool,unsigned> mapping = context.pointer_map(data);
      dump_unsigned(context,mapping.second);
      // if the address is null, then that is all that we need to do
      // however, if it is non-null and this is the first sight of the address, dump the contents
      if (data && !mapping.first)
      {
        // interface method
        // the lookup just finds the magic key and the type has a dump method
        // this will throw persistent_illegal_type if the type is not registered
        unsigned key = context.lookup_interface(typeid(*data));
        // dump the magic key for the type
        dump_unsigned(context, key);
        // now call the dump method defined by the interface
        data->dump(context);
      }
    }
    catch (const persistent_illegal_type& except)
    {
      // convert this to a simpler dump failed exception
      throw persistent_dump_failed(except.what());
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T>
  void restore_interface(restore_context& context, T*& data)
    throw(persistent_restore_failed)
  {
    try
    {
      // first delete any previous object pointed to since the restore creates the object of the right subclass
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
        // seen before, so simply map it to the existing address
        data = (T*)address.second;
      }
      else
      {
        // now restore the magic key that denotes the particular subclass
        unsigned key = 0;
        restore_unsigned(context, key);
        // interface approach
        // first clone the sample object stored in the map - lookup_interface can throw persistent_illegal_type
        data = (T*)(context.lookup_interface(key)->clone());
        // add this pointer to the set of already seen objects
        // do this before restoring the object so that self-referential structures restore correctly
        context.pointer_add(magic,data);
        // now restore the contents using the object's method
        data->restore(context);
      }
    }
    catch (const persistent_illegal_type& exception)
    {
      // convert this to a simpler dump failed exception
      throw persistent_restore_failed(exception.what());
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
