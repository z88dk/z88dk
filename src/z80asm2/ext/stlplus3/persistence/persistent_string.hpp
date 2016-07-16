#ifndef STLPLUS_PERSISTENT_STRING
#define STLPLUS_PERSISTENT_STRING
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Persistence for STL strings

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include <string>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  // basic_string

  template<typename charT, typename traits, typename allocator, typename D>
  void dump_basic_string(dump_context&, const std::basic_string<charT,traits,allocator>& data, D dump_fn)
    throw(persistent_dump_failed);

  template<typename charT, typename traits, typename allocator, typename R>
  void restore_basic_string(restore_context&, std::basic_string<charT,traits,allocator>& data, R restore_fn)
    throw(persistent_restore_failed);

  // string

  void dump_string(dump_context&, const std::string& data)
    throw(persistent_dump_failed);

  void restore_string(restore_context&, std::string& data) 
    throw(persistent_restore_failed);


  // Note: persistence of wstring not supported because it is too weakly defined and messy
  //       decide on a byte-wide encoding of wide strings (e.g. UTF8) and use the string persistence on that

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#include "persistent_string.tpp"
#endif
