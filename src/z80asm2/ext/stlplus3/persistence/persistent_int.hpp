#ifndef STLPLUS_PERSISTENT_INT
#define STLPLUS_PERSISTENT_INT
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of basic integer types

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"

namespace stlplus
{

  void dump_char(dump_context&, const char& data) throw(persistent_dump_failed);
  void restore_char(restore_context&, char& data) throw(persistent_restore_failed);

  void dump_signed_char(dump_context&, const signed char& data) throw(persistent_dump_failed);
  void restore_signed_char(restore_context&, signed char& data) throw(persistent_restore_failed);

  void dump_unsigned_char(dump_context&, const unsigned char& data) throw(persistent_dump_failed);
  void restore_unsigned_char(restore_context&, unsigned char& data) throw(persistent_restore_failed);

  void dump_short(dump_context&, const short& data) throw(persistent_dump_failed);
  void restore_short(restore_context&, short& data) throw(persistent_restore_failed);

  void dump_unsigned_short(dump_context&, const unsigned short& data) throw(persistent_dump_failed);
  void restore_unsigned_short(restore_context&, unsigned short& data) throw(persistent_restore_failed);

  void dump_int(dump_context&, const int& data) throw(persistent_dump_failed);
  void restore_int(restore_context&, int& data) throw(persistent_restore_failed);

  void dump_unsigned(dump_context&, const unsigned& data) throw(persistent_dump_failed);
  void restore_unsigned(restore_context&, unsigned& data) throw(persistent_restore_failed);

  void dump_long(dump_context&, const long& data) throw(persistent_dump_failed);
  void restore_long(restore_context&, long& data) throw(persistent_restore_failed);

  void dump_unsigned_long(dump_context&, const unsigned long& data) throw(persistent_dump_failed);
  void restore_unsigned_long(restore_context&, unsigned long& data) throw(persistent_restore_failed);

  void dump_size_t(dump_context&, const size_t& data) throw(persistent_dump_failed);
  void restore_size_t(restore_context&, size_t& data) throw(persistent_restore_failed);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
