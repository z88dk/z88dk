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
  // enumeration types

  template<typename T>
  void dump_enum(dump_context& context, const T& data)
    throw(persistent_dump_failed)
  {
    dump_unsigned(context,(unsigned)data);
  }

  template<typename T>
  void restore_enum(restore_context& context, T& data)
    throw(persistent_restore_failed)
  {
    unsigned value = 0;
    restore_unsigned(context, value);
    data = (T)value;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
