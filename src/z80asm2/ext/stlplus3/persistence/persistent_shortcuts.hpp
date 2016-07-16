#ifndef STLPLUS_PERSISTENT_SHORTCUTS
#define STLPLUS_PERSISTENT_SHORTCUTS
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Short-cut functions for dumping and restoring to common targets. These do
//   the whole dump operation in a single function call.

//   They take as their second template argument a dump or restore functor which
//   is then called to perform the dump/restore operation.

//   They use an installer callback function to install any polymorphic type
//   handlers required prior to performing the dump/restore. If there are no
//   polymorphic types used in the data structure, then the callback can be set
//   to null (i.e. 0).

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // arbitrary IOStream device
  // must be in binary mode

  template<typename T, class D>
  void dump_to_device(const T& source, std::ostream& result, D dump_fn, dump_context::installer installer)
    throw(persistent_dump_failed);

  template<typename T, class R>
  void restore_from_device(std::istream& source, T& result, R restore_fn, restore_context::installer installer)
    throw(persistent_restore_failed);

  ////////////////////////////////////////////////////////////////////////////////
  // string IO device

  template<typename T, class D>
  void dump_to_string(const T& source, std::string& result, D dump_fn, dump_context::installer installer)
    throw(persistent_dump_failed);

  template<typename T, class R>
  void restore_from_string(const std::string& source, T& result, R restore_fn, restore_context::installer installer)
    throw(persistent_restore_failed);

  ////////////////////////////////////////////////////////////////////////////////
  // file IO device

  template<typename T, class D>
  void dump_to_file(const T& source, const std::string& filename, D dump_fn, dump_context::installer installer)
    throw(persistent_dump_failed);

  template<typename T, class R>
  void restore_from_file(const std::string& filename, T& result, R restore_fn, restore_context::installer installer)
    throw(persistent_restore_failed);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_shortcuts.tpp"
#endif
