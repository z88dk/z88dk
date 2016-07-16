#ifndef STLPLUS_PERSISTENT_BITSET
#define STLPLUS_PERSISTENT_BITSET
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence of STL bitset

////////////////////////////////////////////////////////////////////////////////

#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <bitset>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  template<size_t N>
  void dump_bitset(dump_context&, const std::bitset<N>& data) throw(persistent_dump_failed);

  template<size_t N>
  void restore_bitset(restore_context&, std::bitset<N>& data) throw(persistent_restore_failed);

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_bitset.tpp"
#endif
