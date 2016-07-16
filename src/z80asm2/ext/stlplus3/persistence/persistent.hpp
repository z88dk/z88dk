#ifndef STLPLUS_PERSISTENT
#define STLPLUS_PERSISTENT
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Interface class inherited by classes using the interface approach to polymorphism

////////////////////////////////////////////////////////////////////////////////

#include "persistence_fixes.hpp"
#include "persistent_exceptions.hpp"

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  class dump_context;
  class restore_context;

  class persistent
  {
  public:
    virtual void dump(dump_context&) const throw(persistent_dump_failed) = 0;
    virtual void restore(restore_context&) throw(persistent_restore_failed) = 0;
    virtual persistent* clone(void) const = 0;
    virtual ~persistent(void) {}
  };

} // end namespace stlplus

  ////////////////////////////////////////////////////////////////////////////////
#endif
