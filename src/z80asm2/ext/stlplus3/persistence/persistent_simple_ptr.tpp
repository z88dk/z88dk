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
void stlplus::dump_simple_ptr(stlplus::dump_context& context, const stlplus::simple_ptr<T>& data,
                              DE dump_element)
  throw(stlplus::persistent_dump_failed)
{
  // Many smart pointers can point to the same object.
  // I could have used the address of the object to differentiate, 
  // but that would not have differentiated between different null smart pointers
  // so I use the address of the count to differentiate between different objects.
  // get a magic key for the substructure - this also returns a flag saying whether its been seen before
  std::pair<bool,unsigned> mapping = context.object_map(data._count());
  // dump the magic key for the count
  stlplus::dump_unsigned(context,mapping.second);
  // dump the contents always - this is because I need to rely on the pointer routines dumping a second magic key
  // use the existing routines for ordinary pointers to dump the contents
  stlplus::dump_pointer(context,data._pointer(),dump_element);
}

template<typename T, typename RE>
void stlplus::restore_simple_ptr(stlplus::restore_context& context, stlplus::simple_ptr<T>& data,
                                 RE restore_element)
  throw(stlplus::persistent_restore_failed)
{
  // get the old counter magic key
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
    context.object_add(magic,data._count());
    // now restore the object
    T* value = 0;
    stlplus::restore_pointer(context,value,restore_element);
    // and add it to the pointer
    data.set(value);
  }
  else
  {
    // this holder has already been restored
    // now restore the object and rely on the pointer routines to return the existing object
    T* value = 0;
    stlplus::restore_pointer(context,value,restore_element);
    // dealias the existing holder and replace it with the seen-before holder to make this object an alias of it
    unsigned* holder = (unsigned*)mapping.second;
    data._make_alias(value, holder);
  }
}

////////////////////////////////////////////////////////////////////////////////
// simple_ptr_clone using callbacks

template<typename T>
void stlplus::dump_simple_ptr_clone_callback(stlplus::dump_context& context, const stlplus::simple_ptr_clone<T>& data)
  throw(stlplus::persistent_dump_failed)
{
  std::pair<bool,unsigned> mapping = context.object_map(data._count());
  stlplus::dump_unsigned(context,mapping.second);
  stlplus::dump_callback(context,data._pointer());
}

template<typename T>
void stlplus::restore_simple_ptr_clone_callback(stlplus::restore_context& context, stlplus::simple_ptr_clone<T>& data)
  throw(stlplus::persistent_restore_failed)
{
  unsigned magic = 0;
  stlplus::restore_unsigned(context,magic);
  std::pair<bool,void*> mapping = context.object_map(magic);
  if (!mapping.first)
  {
    data.clear_unique();
    context.object_add(magic,data._count());
    T* value = 0;
    stlplus::restore_callback(context,value);
    data.set(value);
  }
  else
  {
    T* value = 0;
    stlplus::restore_callback(context,value);
    data._make_alias(value, (unsigned*)mapping.second);
  }
}

////////////////////////////////////////////////////////////////////////////////
// simple_ptr_clone using interface

template<typename T>
void stlplus::dump_simple_ptr_clone_interface(stlplus::dump_context& context, const stlplus::simple_ptr_clone<T>& data)
  throw(stlplus::persistent_dump_failed)
{
  std::pair<bool,unsigned> mapping = context.object_map(data._count());
  stlplus::dump_unsigned(context,mapping.second);
  stlplus::dump_interface(context,data._pointer());
}

template<typename T>
void stlplus::restore_simple_ptr_clone_interface(stlplus::restore_context& context, stlplus::simple_ptr_clone<T>& data)
  throw(stlplus::persistent_restore_failed)
{
  unsigned magic = 0;
  stlplus::restore_unsigned(context,magic);
  std::pair<bool,void*> mapping = context.object_map(magic);
  if (!mapping.first)
  {
    data.clear_unique();
    context.object_add(magic,data._count());
    T* value = 0;
    stlplus::restore_interface(context,value);
    data.set(value);
  }
  else
  {
    T* value = 0;
    stlplus::restore_interface(context,value);
    data._make_alias(value, (unsigned*)mapping.second);
  }
}

////////////////////////////////////////////////////////////////////////////////
