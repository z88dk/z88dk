#ifndef STLPLUS_PERSISTENT_SIMPLE_PTR
#define STLPLUS_PERSISTENT_SIMPLE_PTR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STLplus simple_ptr

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include "simple_ptr.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  // simple_ptr - uses dump/restore_pointer on the contents

  template<typename T, typename DE>
  void dump_simple_ptr(dump_context&, const simple_ptr<T>& data, DE dump_element)
    throw(persistent_dump_failed);

  template<typename T, typename RE>
  void restore_simple_ptr(restore_context&, simple_ptr<T>& data, RE restore_element)
    throw(persistent_restore_failed);

  // simple_ptr_clone using the polymorphic callback approach - uses dump/restore_callback on the contents

  template<typename T>
  void dump_simple_ptr_clone_callback(dump_context&, const simple_ptr_clone<T>& data)
    throw(persistent_dump_failed);

  template<typename T>
  void restore_simple_ptr_clone_callback(restore_context&, simple_ptr_clone<T>& data)
    throw(persistent_restore_failed);

  // simple_ptr_clone using the interface approach - uses dump/restore_interface on the contents

  template<typename T>
  void dump_simple_ptr_clone_interface(dump_context&, const simple_ptr_clone<T>& data)
    throw(persistent_dump_failed);

  template<typename T>
  void restore_simple_ptr_clone_interface(restore_context&, simple_ptr_clone<T>& data)
    throw(persistent_restore_failed);

  // simple_ptr_nocopy is not made persistent because if it is uncopyable, it must be undumpable

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_simple_ptr.tpp"
#endif
