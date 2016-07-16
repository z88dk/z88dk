////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards-2009
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_float.hpp"

////////////////////////////////////////////////////////////////////////////////
// Macro for mapping either endian data onto little-endian addressing to make
// my life easier in writing this code! I think better in little-endian mode
// so the macro does nothing in that mode but maps little-endian onto
// big-endian addressing in big-endian mode
// TODO - make this compile-time configurable

#define INDEX(index) ((context.little_endian()) ? (index) : ((bytes) - (index) - 1))

/////////////////////////////////////////////////////////////////////
// floating point types
// format: {size}{byte}*size
// ordering is msB first

// this uses a similar mechanism to integer dumps. However, it is not clear how
// the big-endian and little-endian argument applies to multi-word data so
// this may need reworking by splitting into words and then bytes.

namespace stlplus
{

  static void dump_float(stlplus::dump_context& context, unsigned bytes, unsigned char* data)
    throw(stlplus::persistent_dump_failed)
  {
    unsigned i = bytes;
    // put the size
    context.put((unsigned char)i);
    // and put the bytes
    while(i--)
      context.put(data[INDEX(i)]);
  }

  static void restore_float(stlplus::restore_context& context, unsigned bytes, unsigned char* data)
    throw(stlplus::persistent_restore_failed)
  {
    // get the dumped size from the file
    unsigned dumped_bytes = (unsigned)context.get();
    // get the bytes from the file
    unsigned i = dumped_bytes;
    while(i--)
    {
      int ch = context.get();
      if (i < bytes)
        data[INDEX(i)] = (unsigned char)ch;
    }
    // however, if the dumped size was different I don't know how to map the formats, so give an error
    if (dumped_bytes != bytes)
      throw stlplus::persistent_restore_failed(std::string("size mismatch"));
  }

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
  // exported functions which simply call the low-level byte-dump and byte-restore routines above

void stlplus::dump_float(stlplus::dump_context& context, const float& data) throw(stlplus::persistent_dump_failed)
{
  stlplus::dump_float(context, sizeof(float), (unsigned char*)&data);
}

void stlplus::restore_float(restore_context& context, float& data) throw(stlplus::persistent_restore_failed)
{
  stlplus::restore_float(context, sizeof(float), (unsigned char*)&data);
}

void stlplus::dump_double(stlplus::dump_context& context, const double& data) throw(stlplus::persistent_dump_failed)
{
  stlplus::dump_float(context, sizeof(double), (unsigned char*)&data);
}

void stlplus::restore_double(restore_context& context, double& data) throw(stlplus::persistent_restore_failed)
{
  stlplus::restore_float(context, sizeof(double), (unsigned char*)&data);
}

////////////////////////////////////////////////////////////////////////////////
