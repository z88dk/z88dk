////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_bool.hpp"

////////////////////////////////////////////////////////////////////////////////

// bool is dumped and restored as an unsigned char
void stlplus::dump_bool(stlplus::dump_context& context, const bool& data) throw(stlplus::persistent_dump_failed)
{
  context.put((unsigned char)data);
}

void stlplus::restore_bool(restore_context& context, bool& data) throw(stlplus::persistent_restore_failed)
{
  data = context.get() != 0;
}

////////////////////////////////////////////////////////////////////////////////
