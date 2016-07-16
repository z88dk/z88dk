////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

#include "persistent_cstring.hpp"
#include "persistent_int.hpp"
#include <string.h>

////////////////////////////////////////////////////////////////////////////////
// Null-terminated char arrays
// Format: address [ size data ]

void stlplus::dump_cstring(stlplus::dump_context& context, const char* data) throw(stlplus::persistent_dump_failed)
{
  // register the address and get the magic key for it
  std::pair<bool,unsigned> mapping = context.pointer_map(data);
  stlplus::dump_unsigned(context,mapping.second);
  // if the address is null, then that is all that we need to do
  // however, if it is non-null and this is the first sight of the address, dump the contents
  if (data && !mapping.first)
  {
    size_t size = strlen(data);
    stlplus::dump_size_t(context,size);
    for (unsigned i = 0; i < size; i++)
      stlplus::dump_char(context,data[i]);
  }
}

void stlplus::restore_cstring(restore_context& context, char*& data) throw(stlplus::persistent_restore_failed)
{
  // destroy any previous contents
  if (data)
  {
    delete[] data;
    data = 0;
  }
  // get the magic key
  unsigned magic = 0;
  stlplus::restore_unsigned(context,magic);
  // now lookup the magic key to see if this pointer has already been restored
  // null pointers are always flagged as already restored
  std::pair<bool,void*> address = context.pointer_map(magic);
  if (!address.first)
  {
    // this pointer has never been seen before and is non-null
    // restore the string
    size_t size = 0;
    stlplus::restore_size_t(context,size);
    data = new char[size+1];
    for (size_t i = 0; i < size; i++)
      stlplus::restore_char(context,data[i]);
    data[size] = '\0';
    // add this pointer to the set of already seen objects
    context.pointer_add(magic,data);
  }
}

////////////////////////////////////////////////////////////////////////////////
