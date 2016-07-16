////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_vector.hpp"

////////////////////////////////////////////////////////////////////////////////
// specialisation for a vector of bool which has a different implementation to a vector of anything else

void stlplus::dump_vector_bool(stlplus::dump_context& context, const std::vector<bool>& data)
  throw(stlplus::persistent_dump_failed)
{
  stlplus::dump_size_t(context,data.size());
  size_t size = data.size();
  size_t bytes = ((size + 7) / 8);
  for (size_t b = 0; b < bytes; b++)
  {
    unsigned char byte = 0;
    unsigned char mask = 1;
    for (unsigned e = 0; e < 8; e++)
    {
      size_t i = b*8 + e;
      if (i >= size) break;
      if (data[i]) byte |= mask;
      mask <<= 1;
    }
    context.put(byte);
  }
}

void stlplus::restore_vector_bool(stlplus::restore_context& context, std::vector<bool>& data)
  throw(stlplus::persistent_restore_failed)
{
  size_t size = 0;
  stlplus::restore_size_t(context,size);
  data.resize(size);
  size_t bytes = ((size + 7) / 8);
  for (size_t b = 0; b < bytes; b++)
  {
    unsigned char byte = context.get();
    unsigned char mask = 1;
    for (unsigned e = 0; e < 8; e++)
    {
      size_t i = b*8 + e;
      if (i >= size) break;
      data[i] = ((byte & mask) != 0);
      mask <<= 1;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
