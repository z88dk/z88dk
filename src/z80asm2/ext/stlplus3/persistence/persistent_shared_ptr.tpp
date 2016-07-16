////////////////////////////////////////////////////////////////////////////////
//
//   Author:    Andy Rushton
//   Copyright: (c) Andy Rushton           2010 onwards
//   License:   BSD License, see ../docs/license.html
//
// Many shared pointers can point to the same object. I have used the
// address of the pointed-to object so that shared pointers to the
// same object can be restored as shared pointers to the same
// object. 
//
// However, this solution does not differentiated between different
// null shared pointers. I don't know of a solution to this problem at
// present, but I also don't know of a case where it is a problem.
//
// Also you must dump the shared_ptr before any simple pointers to
// this object (actually you shouldn't be using simple pointers).
//
////////////////////////////////////////////////////////////////////////////////

#include "persistent_int.hpp"
#include "persistent_pointer.hpp"
#include "persistent_callback.hpp"
#include "persistent_interface.hpp"

////////////////////////////////////////////////////////////////////////////////

template<typename  T, typename DE>
void stlplus::dump_shared_ptr(stlplus::dump_context& context, const std::shared_ptr<T>& data,
                              DE dump_element)
  throw(stlplus::persistent_dump_failed)
{
  // I have to handle empty and null shared pointers as a special case, which
  // means the file format is different from other pointer types
  unsigned classification = (data.use_count() == 0) ? 0 : (data.get() == 0) ? 1 : 2;
  stlplus::dump_unsigned(context, classification);
  if (classification == 2)
  {
    // get a magic key for the object - this also returns a flag saying whether its been seen before
    std::pair<bool,unsigned> mapping = context.object_map(data.get());
    // dump the magic key
    stlplus::dump_unsigned(context,mapping.second);
    // dump the contents but only if this is the first time this object has been seen
    // use the existing routines for ordinary pointers to dump the contents
    if (!mapping.first)
      stlplus::dump_pointer(context, data.get(), dump_element);
  }
}

template<typename T, typename RE>
void stlplus::restore_shared_ptr(stlplus::restore_context& context, std::shared_ptr<T>& data,
                                 RE restore_element)
  throw(stlplus::persistent_restore_failed)
{
  // get the classification
  unsigned classification = 0;
  stlplus::restore_unsigned(context, classification);
  switch(classification)
  {
  case 0:
  {
    // empty pointer
    data.reset();
    break;
  }
  case 1:
  {
    // null pointer
    data.reset((T*)0);
    break;
  }
  case 2:
  {
    // get the old substructure magic key
    unsigned magic = 0;
    stlplus::restore_unsigned(context,magic);
    // lookup this magic number to see if we have seen this already
    std::pair<bool,void*> mapping = context.object_map(magic);
    if (!mapping.first)
    {
      // this is the first contact with this object
      // map the magic key onto this shared pointer which becomes the master pointer
      // do this before restoring the object so that self-referential structures restore correctly
      context.object_add(magic,&data);
      // now restore the object
      T* value = 0;
      stlplus::restore_pointer(context, value, restore_element);
      data.reset(value);
    }
    else
    {
      // this object has already been restored
      // the mapping contains the address of the master shared pointer, so make data an alias of it
      data = *(std::shared_ptr<T>*)mapping.second;
    }
  }
  }
}

////////////////////////////////////////////////////////////////////////////////
// shared_ptr and polymorphic types using callbacks

template<typename T>
void stlplus::dump_shared_ptr_callback(stlplus::dump_context& context, const std::shared_ptr<T>& data)
  throw(stlplus::persistent_dump_failed)
{
  // same as for non-polymorphic types except for how the pointer is dumped
  unsigned classification = (data.use_count() == 0) ? 0 : (data.get() == 0) ? 1 : 2;
  stlplus::dump_unsigned(context, classification);
  if (classification == 2)
  {
    // get a magic key for the object - this also returns a flag saying whether its been seen before
    std::pair<bool,unsigned> mapping = context.object_map(data.get());
    // dump the magic key
    stlplus::dump_unsigned(context,mapping.second);
    // dump the contents but only if this is the first time this object has been seen
    // use the existing callback routines to dump the contents
    if (!mapping.first)
    {
      // callback method - get the callback data and perform the dump
      stlplus::dump_callback(context,data.get());
    }
  }
}

template<typename T>
void stlplus::restore_shared_ptr_callback(stlplus::restore_context& context, std::shared_ptr<T>& data)
  throw(stlplus::persistent_restore_failed)
{
  // get the classification
  unsigned classification = 0;
  stlplus::restore_unsigned(context, classification);
  switch(classification)
  {
  case 0:
  {
    // empty pointer
    data.reset();
    break;
  }
  case 1:
  {
    // null pointer
    data.reset((T*)0);
    break;
  }
  case 2:
  {
    // get the old substructure magic key
    unsigned magic = 0;
    stlplus::restore_unsigned(context,magic);
    // lookup this magic number to see if we have seen this already
    std::pair<bool,void*> mapping = context.object_map(magic);
    if (!mapping.first)
    {
      // this is the first contact with this holder
      // map the magic key onto this structure's holder
      // do this before restoring the object so that self-referential structures restore correctly
      context.object_add(magic,data.get());
      // now restore the object
      T* value = 0;
      stlplus::restore_callback(context,value);
      data.reset(value);
    }
    else
    {
      // this object has already been restored
      // the mapping contains the address of the master shared pointer, so make data an alias of it
      data = *(std::shared_ptr<T>*)mapping.second;
    }
  }
  }
}

////////////////////////////////////////////////////////////////////////////////
// shared_ptr and polymorphic types using interfaces

template<typename T>
void stlplus::dump_shared_ptr_interface(stlplus::dump_context& context, const std::shared_ptr<T>& data)
  throw(stlplus::persistent_dump_failed)
{
  // same as for non-polymorphic types except for how the pointer is dumped
  unsigned classification = (data.use_count() == 0) ? 0 : (data.get() == 0) ? 1 : 2;
  stlplus::dump_unsigned(context, classification);
  if (classification == 2)
  {
    // get a magic key for the object - this also returns a flag saying whether its been seen before
    std::pair<bool,unsigned> mapping = context.object_map(data.get());
    // dump the magic key
    stlplus::dump_unsigned(context,mapping.second);
    // dump the contents but only if this is the first time this object has been seen
    // use the existing interface routines to dump the contents
    if (!mapping.first)
      stlplus::dump_interface(context,data.get());
  }
}

template<typename T>
void stlplus::restore_shared_ptr_interface(stlplus::restore_context& context, std::shared_ptr<T>& data)
  throw(stlplus::persistent_restore_failed)
{
  // get the classification
  unsigned classification = 0;
  stlplus::restore_unsigned(context, classification);
  switch(classification)
  {
  case 0:
  {
    // empty pointer
    data.reset();
    break;
  }
  case 1:
  {
    // null pointer
    data.reset((T*)0);
    break;
  }
  case 2:
  {
    // get the old substructure magic key
    unsigned magic = 0;
    stlplus::restore_unsigned(context,magic);
    // lookup this magic number to see if we have seen this already
    std::pair<bool,void*> mapping = context.object_map(magic);
    if (!mapping.first)
    {
      // this is the first contact with this holder
      // map the magic key onto this structure's holder
      // do this before restoring the object so that self-referential structures restore correctly
      context.object_add(magic,data._handle());
      // now restore the object
      T* value = 0;
      stlplus::restore_interface(context,value);
      data.reset(value);
    }
    else
    {
      // this object has already been restored
      // the mapping contains the address of the master shared pointer, so make data an alias of it
      data = *(std::shared_ptr<T>*)mapping.second;
    }
  }
  }
}

////////////////////////////////////////////////////////////////////////////////
