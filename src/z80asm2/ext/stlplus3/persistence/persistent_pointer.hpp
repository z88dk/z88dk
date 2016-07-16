#ifndef STLPLUS_PERSISTENT_POINTER
#define STLPLUS_PERSISTENT_POINTER
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence for pointers to persistent objects

//   Warning! The pointer must be a dynamically-allocated type, since the
//   implementation uses new/delete

//   Multiple pointers to the same object *will* be restored as multiple pointers
//   to the same object. The object is dumped only the first time it is
//   encountered along with a "magic key". Subsequent pointers to the same object
//   cause only the magic key to be dumped. On restore, the object is only
//   restored once and the magic keys are matched up so that the other pointers
//   now point to the restored object.

//   Supports null pointers too! If the data field to restore is null and the
//   file format non-null, allocates a new T(). If the data field is non-null and
//   the file format is null, deletes it and sets it null

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<typename T, typename D>
  void dump_pointer(dump_context&, const T* const data, D dump_fn)
    throw(persistent_dump_failed);

  template<typename T, typename R>
  void restore_pointer(restore_context&, T*& data, R restore_fn)
    throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_pointer.tpp"
#endif
