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
  // format: data msB first, packed into bytes with lowest index at the byte's lsb

  // Note: the interface does not provide access to the internal storage and yet
  // to be efficient the std::bitset must be packed as bytes. Thus I have to do it the
  // hard way.

  template<size_t N>
  void dump_bitset(dump_context& context, const std::bitset<N>& data)
    throw(persistent_dump_failed)
  {
    size_t bits = data.size();
    size_t bytes = (bits+7)/8;
    for (size_t B = bytes; B--; )
    {
      unsigned char ch = 0;
      for (size_t b = 0; b < 8; b++)
      {
        size_t bit = B*8+b;
        if (bit < bits && data.test(bit))
          ch |= (0x01 << b);
      }
      dump_unsigned_char(context,ch);
    }
  }

  template<size_t N>
  void restore_bitset(restore_context& context, std::bitset<N>& data)
    throw(persistent_restore_failed)
  {
    size_t bits = data.size();
    size_t bytes = (bits+7)/8;
    for (size_t B = bytes; B--; )
    {
      unsigned char ch = 0;
      restore_unsigned_char(context,ch);
      for (size_t b = 0; b < 8; b++)
      {
        size_t bit = B*8+b;
        if (bit >= bits) break;
        data.set(bit, ch & (0x01 << b) ? true : false);
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
