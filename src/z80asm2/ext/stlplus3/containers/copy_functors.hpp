#ifndef STLPLUS_COPY_FUNCTORS
#define STLPLUS_COPY_FUNCTORS
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   The function constructor classes below are used by the smart_ptr and the
//   simple_ptr classes. They provide three (well ok, two) copying mechanisms.
//   These classes have been separated from the smart_ptr header by DJDM, as
//   the simple_ptr classes now also use them.

////////////////////////////////////////////////////////////////////////////////
#include "containers_fixes.hpp"
#include "exceptions.hpp"

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // copy functors implementing the three possible copy semantics

  // constructor_copy uses the copy constructor of the object - used for simple types

  template <typename T>
  class constructor_copy
  {
  public:
    T* operator() (const T& from) throw()
      {
        return new T(from);
      }
  };

  // clone_copy uses the clone method of the object - used for polymorphic types

  template <typename T>
  class clone_copy
  {
  public:
    T* operator() (const T& from) throw()
      {
        return from.clone();
      }
  };

  // no_copy throws an exception - used for types that cannot be copied

  template <typename T>
  class no_copy
  {
  public:
    T* operator() (const T& from) throw(illegal_copy)
      {
        throw illegal_copy("no_copy functor called");
        return 0;
      }
  };

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
