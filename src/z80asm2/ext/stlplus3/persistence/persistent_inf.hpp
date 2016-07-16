#ifndef STLPLUS_PERSISTENT_INF
#define STLPLUS_PERSISTENT_INF
////////////////////////////////////////////////////////////////////////////////

//     Author:    Andy Rushton
//     Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//     License:   BSD License, see ../docs/license.html
  
//     Persistence of stlplus infinite integer type - inf

////////////////////////////////////////////////////////////////////////////////
#include "persistence_fixes.hpp"
#include "persistent_contexts.hpp"
#include "inf.hpp"

namespace stlplus
{

  void dump_inf(dump_context&, const inf& data) throw(persistent_dump_failed);
  void restore_inf(restore_context&, inf& data) throw(persistent_restore_failed);

} // end namespace stlplus

#endif
