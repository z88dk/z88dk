////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"

////////////////////////////////////////////////////////////////////////////////
// Macro for mapping either endian data onto little-endian addressing to make
// my life easier in writing this code! I think better in little-endian mode
// so the macro does nothing in that mode but maps little-endian onto
// big-endian addressing in big-endian mode
// TODO - make this compile-time configurable so it's more efficient

#define INDEX(index) ((context.little_endian()) ? (index) : ((bytes) - (index) - 1))

////////////////////////////////////////////////////////////////////////////////
// Integer types
// format: {size}{byte}*size
// size can be zero!
//
// A major problem is that integer types may be different sizes on different
// machines or even with different compilers on the same machine (though I
// haven't come across that yet). Neither the C nor the C++ standards specify
// the size of integer types. Dumping an int on one machine might dump 16
// bits. Restoring it on another machine might try to restore 32 bits. These
// functions must therefore handle different type sizes. It does this by
// writing the size to the file as well as the data, so the restore can
// therefore know how many bytes to restore independent of the type size.
//
// In fact, the standard does not even specify the size of char (true! And
// mind-numbingly stupid...). However, to be able to do anything at all, I've
// had to assume that a char is 1 byte.

static void dump_unsigned(stlplus::dump_context& context, unsigned bytes, unsigned char* data)
  throw(stlplus::persistent_dump_failed)
{
  // first skip zero bytes - this may reduce the data to zero bytes long
  unsigned i = bytes;
  while(i >= 1 && data[INDEX(i-1)] == 0)
    i--;
  // put the remaining size
  context.put((unsigned char)i);
  // and put the bytes
  while(i--)
    context.put(data[INDEX(i)]);
}

static void dump_signed(stlplus::dump_context& context, unsigned bytes, unsigned char* data)
  throw(stlplus::persistent_dump_failed)
{
  // first skip all-zero or all-one bytes but only if doing so does not change the sign
  unsigned i = bytes;
  if (data[INDEX(i-1)] < 128)
  {
    // positive number so discard leading zeros but only if the following byte is positive
    while(i >= 2 && data[INDEX(i-1)] == 0 && data[INDEX(i-2)] < 128)
      i--;
  }
  else
  {
    // negative number so discard leading ones but only if the following byte is negative
    while(i >= 2 && data[INDEX(i-1)] == 255 && data[INDEX(i-2)] >= 128)
      i--;
  }
  // put the remaining size
  context.put((unsigned char)i);
  // and put the bytes
  while(i--)
    context.put(data[INDEX(i)]);
}

static void restore_unsigned(stlplus::restore_context& context, unsigned bytes, unsigned char* data)
  throw(stlplus::persistent_restore_failed)
{
  // get the dumped size from the file
  unsigned dumped_bytes = (unsigned)context.get();
  // zero fill any empty space
  unsigned i = bytes;
  for (; i > dumped_bytes; i--)
    data[INDEX(i-1)] = 0;
  // restore the dumped bytes but discard any that don't fit
  while(i--)
  {
    int ch = context.get();
    if (i < bytes)
      data[INDEX(i)] = (unsigned char)ch;
    else
      throw stlplus::persistent_restore_failed(std::string("integer overflow"));
  }
}

static void restore_signed(stlplus::restore_context& context, unsigned bytes, unsigned char* data)
  throw(stlplus::persistent_restore_failed)
{
  // get the dumped size from the file
  unsigned dumped_bytes = (unsigned)context.get();
  // restore the dumped bytes but discard any that don't fit
  unsigned i = dumped_bytes;
  while(i--)
  {
    int ch = context.get();
    if (i < bytes)
      data[INDEX(i)] = (unsigned char)ch;
    else
      throw stlplus::persistent_restore_failed(std::string("integer overflow"));
  }
  // sign extend if the dumped integer was smaller
  if (dumped_bytes < bytes)
  {
    if (data[INDEX(dumped_bytes-1)] < 128)
    {
      // positive so zero fill
      for (i = dumped_bytes; i < bytes; i++)
        data[INDEX(i)] = 0;
    }
    else
    {
      // negative so one fill
      for (i = dumped_bytes; i < bytes; i++)
        data[INDEX(i)] = 0xff;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
// exported functions

// char is dumped and restored as an unsigned char because the signedness of char is not defined and can vary
void stlplus::dump_char(stlplus::dump_context& context, const char& data) throw(stlplus::persistent_dump_failed)
{
  context.put((unsigned char)data);
}

void stlplus::restore_char(restore_context& context, char& data) throw(stlplus::persistent_restore_failed)
{
  data = (char)(unsigned char)context.get();
}

void stlplus::dump_signed_char(stlplus::dump_context& context, const signed char& data) throw(stlplus::persistent_dump_failed)
{
  context.put((unsigned char)data);
}

void stlplus::restore_signed_char(restore_context& context, signed char& data) throw(stlplus::persistent_restore_failed)
{
  data = (signed char)(unsigned char)context.get();
}

void stlplus::dump_unsigned_char(stlplus::dump_context& context, const unsigned char& data) throw(stlplus::persistent_dump_failed)
{
  context.put((unsigned char)data);
}

void stlplus::restore_unsigned_char(restore_context& context, unsigned char& data) throw(stlplus::persistent_restore_failed)
{
  data = (signed char)(unsigned char)context.get();
}

void stlplus::dump_short(stlplus::dump_context& context, const short& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_signed(context, sizeof(short), (unsigned char*)&data);
}

void stlplus::restore_short(restore_context& context, short& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_signed(context, sizeof(short),(unsigned char*)&data);
}

void stlplus::dump_unsigned_short(stlplus::dump_context& context, const unsigned short& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_unsigned(context, sizeof(unsigned short), (unsigned char*)&data);
}

void stlplus::restore_unsigned_short(restore_context& context, unsigned short& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_unsigned(context, sizeof(unsigned short),(unsigned char*)&data);
}

void stlplus::dump_int(stlplus::dump_context& context, const int& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_signed(context, sizeof(int), (unsigned char*)&data);
}

void stlplus::restore_int(restore_context& context, int& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_signed(context, sizeof(int),(unsigned char*)&data);
}

void stlplus::dump_unsigned(stlplus::dump_context& context, const unsigned& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_unsigned(context, sizeof(unsigned), (unsigned char*)&data);
}

void stlplus::restore_unsigned(restore_context& context, unsigned& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_unsigned(context, sizeof(unsigned),(unsigned char*)&data);
}

void stlplus::dump_long(stlplus::dump_context& context, const long& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_signed(context, sizeof(long), (unsigned char*)&data);
}

void stlplus::restore_long(restore_context& context, long& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_signed(context, sizeof(long),(unsigned char*)&data);
}

void stlplus::dump_unsigned_long(stlplus::dump_context& context, const unsigned long& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_unsigned(context, sizeof(unsigned long), (unsigned char*)&data);
}

void stlplus::restore_unsigned_long(restore_context& context, unsigned long& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_unsigned(context, sizeof(unsigned long),(unsigned char*)&data);
}

void stlplus::dump_size_t(stlplus::dump_context& context, const size_t& data) throw(stlplus::persistent_dump_failed)
{
  ::dump_unsigned(context, sizeof(size_t), (unsigned char*)&data);
}

void stlplus::restore_size_t(restore_context& context, size_t& data) throw(stlplus::persistent_restore_failed)
{
  ::restore_unsigned(context, sizeof(size_t),(unsigned char*)&data);
}

////////////////////////////////////////////////////////////////////////////////
