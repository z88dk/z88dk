////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"
#include "persistent_pointer.hpp"
#include "persistent_callback.hpp"
#include "persistent_interface.hpp"

////////////////////////////////////////////////////////////////////////////////

template<typename  T, typename DE>
void stlplus::dump_smart_ptr(stlplus::dump_context& context, const stlplus::smart_ptr<T>& data,
                             DE dump_element)
  throw(stlplus::persistent_dump_failed)
{
  // similar to the simple pointer routines, but use the address of the holder to tell which objects are aliases
  // Many smart pointers can point to the same object.
  // I could have used the address of the object to differentiate, 
  // but that would not have differentiated between different null smart pointers
  // so I use the address of the substructure to differentiate between different objects.
  // get a magic key for the substructure - this also returns a flag saying whether its been seen before
  std::pair<bool,unsigned> mapping = context.object_map(data._handle());
  // dump the magic key
  stlplus::dump_unsigned(context,mapping.second);
  // dump the contents but only if this is the first time this object has been seen
  // use the existing routines for ordinary pointers to dump the contents
  if (!mapping.first)
    stlplus::dump_pointer(context,data.pointer(),dump_element);
}

template<typename T, typename RE>
void stlplus::restore_smart_ptr(stlplus::restore_context& context, stlplus::smart_ptr<T>& data,
                                RE restore_element)
  throw(stlplus::persistent_restore_failed)
{
  // get the old substructure magic key
  unsigned magic = 0;
  stlplus::restore_unsigned(context,magic);
  // lookup this magic number to see if we have seen this already
  std::pair<bool,void*> mapping = context.object_map(magic);
  if (!mapping.first)
  {
    // this is the first contact with this holder
    // make sure this smart pointer is unique to prevent side-effects
    data.clear_unique();
    // map the magic key onto this structure's holder
    // do this before restoring the object so that self-referential structures restore correctly
    context.object_add(magic,data._handle());
    // now restore the object
    T* value = 0;
    stlplus::restore_pointer(context,value,restore_element);
    data.set(value);
  }
  else
  {
    // this holder has already been restored
    // dealias the existing holder and replace it with the seen-before holder to make this object an alias of it
    data._make_alias((smart_ptr_holder<T>*)mapping.second);
  }
}

////////////////////////////////////////////////////////////////////////////////
// smart_ptr_clone using callbacks

template<typename T>
void stlplus::dump_smart_ptr_clone_callback(stlplus::dump_context& context, const stlplus::smart_ptr_clone<T>& data)
  throw(stlplus::persistent_dump_failed)
{
  // similar to the simple pointer routines, but use the address of the holder to tell which objects are aliases
  // Many smart pointers can point to the same object.
  // I could have used the address of the object to differentiate, 
  // but that would not have differentiated between different null smart pointers
  // so I use the address of the substructure to differentiate between different objects.
  // get a magic key for the substructure - this also returns a flag saying whether its been seen before
  std::pair<bool,unsigned> mapping = context.object_map(data._handle());
  // dump the magic key
  stlplus::dump_unsigned(context,mapping.second);
  // dump the contents but only if this is the first time this object has been seen
  // use the existing routines for ordinary pointers to dump the contents
  if (!mapping.first)
    stlplus::dump_callback(context,data.pointer());
}

template<typename T>
void stlplus::restore_smart_ptr_clone_callback(stlplus::restore_context& context, stlplus::smart_ptr_clone<T>& data)
  throw(stlplus::persistent_restore_failed)
{
  // get the old substructure magic key
  unsigned magic = 0;
  restore_unsigned(context,magic);
  // lookup this magic number to see if we have seen this already
  std::pair<bool,void*> mapping = context.object_map(magic);
  if (!mapping.first)
  {
    // this is the first contact with this holder
    // make sure this smart pointer is unique to prevent side-effects
    data.clear_unique();
    // map the magic key onto this structure's holder
    // do this before restoring the object so that self-referential structures restore correctly
    context.object_add(magic,data._handle());
    // now restore the object
    T* value = 0;
    restore_callback(context,value);
    data.set(value);
  }
  else
  {
    // this holder has already been restored
    // dealias the existing holder and replace it with the seen-before holder to make this object an alias of it
    data._make_alias((smart_ptr_holder<T>*)mapping.second);
  }
}

////////////////////////////////////////////////////////////////////////////////
// smart_ptr_clone using interface

template<typename T>
void stlplus::dump_smart_ptr_clone_interface(stlplus::dump_context& context, const stlplus::smart_ptr_clone<T>& data)
  throw(stlplus::persistent_dump_failed)
{
  // similar to the simple pointer routines, but use the address of the holder to tell which objects are aliases
  // Many smart pointers can point to the same object.
  // I could have used the address of the object to differentiate, 
  // but that would not have differentiated between different null smart pointers
  // so I use the address of the substructure to differentiate between different objects.
  // get a magic key for the substructure - this also returns a flag saying whether its been seen before
  std::pair<bool,unsigned> mapping = context.object_map(data._handle());
  // dump the magic key
  stlplus::dump_unsigned(context,mapping.second);
  // dump the contents but only if this is the first time this object has been seen
  // use the existing routines for ordinary pointers to dump the contents
  if (!mapping.first)
    stlplus::dump_interface(context,data.pointer());
}

template<typename T>
void stlplus::restore_smart_ptr_clone_interface(stlplus::restore_context& context, stlplus::smart_ptr_clone<T>& data)
  throw(stlplus::persistent_restore_failed)
{
  // get the old substructure magic key
  unsigned magic = 0;
  stlplus::restore_unsigned(context,magic);
  // lookup this magic number to see if we have seen this already
  std::pair<bool,void*> mapping = context.object_map(magic);
  if (!mapping.first)
  {
    // this is the first contact with this holder
    // make sure this smart pointer is unique to prevent side-effects
    data.clear_unique();
    // map the magic key onto this structure's holder
    // do this before restoring the object so that self-referential structures restore correctly
    context.object_add(magic,data._handle());
    // now restore the object
    T* value = 0;
    stlplus::restore_interface(context,value);
    data.set(value);
  }
  else
  {
    // this holder has already been restored
    // dealias the existing holder and replace it with the seen-before holder to make this object an alias of it
    data._make_alias((smart_ptr_holder<T>*)mapping.second);
  }
}

////////////////////////////////////////////////////////////////////////////////
