////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

// can be excluded to break the dependency on the portability library
#ifndef NO_STLPLUS_INF

#include "persistent_int.hpp"
#include "persistent_string.hpp"
#include "persistent_inf.hpp"

////////////////////////////////////////////////////////////////////////////////

void stlplus::dump_inf(stlplus::dump_context& context, const stlplus::inf& data)
  throw(stlplus::persistent_dump_failed)
{
  // don't support dumping of old versions
  if (context.version() < 2)
    throw stlplus::persistent_dump_failed(std::string("stlplus::inf::dump: wrong version"));
  // just dump the string
  stlplus::dump_string(context,data.get_bytes());
}

////////////////////////////////////////////////////////////////////////////////

void stlplus::restore_inf(stlplus::restore_context& context, stlplus::inf& data)
  throw(stlplus::persistent_restore_failed)
{
  if (context.version() < 1)
    throw stlplus::persistent_restore_failed(std::string("stlplus::inf::restore: wrong version"));
  if (context.version() == 1)
  {
    // old-style restore relies on the word size being the same - 32-bits - on all platforms
    // this can be restored on such machines but is not portable to 64-bit machines
    std::string value;
    unsigned bits = 0;
    stlplus::restore_unsigned(context,bits);
    unsigned words = (bits+7)/32;
    // inf was dumped msB first
    for (unsigned i = words; i--; )
    {
      // restore a word
      unsigned word = 0;
      stlplus::restore_unsigned(context,word);
      // now extract the bytes
      unsigned char* byte_ptr = (unsigned char*)(&word);
      for (unsigned b = 4; b--; )
        value.insert(value.begin(),byte_ptr[context.little_endian() ? b : 3 - b]);
    }
    data.set_bytes(value);
  }
  else
  {
    // new-style dump just uses the string persistence
    std::string value;
    stlplus::restore_string(context,value);
    data.set_bytes(value);
  }
}
////////////////////////////////////////////////////////////////////////////////
#endif
