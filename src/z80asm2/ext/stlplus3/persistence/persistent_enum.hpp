#ifndef STLPLUS_PERSISTENT_ENUM
#define STLPLUS_PERSISTENT_ENUM
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of enumeration types

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T>
  void dump_enum(dump_context&, const T& data) throw(persistent_dump_failed);

  template<typename T>
  void restore_enum(restore_context&, T& data) throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_enum.tpp"
#endif
