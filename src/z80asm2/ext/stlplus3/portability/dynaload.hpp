#ifndef STLPLUS_DYNALOAD
#define STLPLUS_DYNALOAD
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   A portable interface to the dynamic loader - i.e. the system for loading
//   dynamic libraries or shared libraries during the running of a program,
//   rather than by linking

////////////////////////////////////////////////////////////////////////////////
#include "portability_fixes.hpp"
#include <string>

namespace stlplus
{

  //////////////////////////////////////////////////////////////////////////////
  // dynaload class manages a dynamic loadable library and unloads it on destruction

  class dynaload
  {
  public:

    ////////////////////////////////////////////////////////////////////////////
    // library management

    // construct the object but do not load
    dynaload(void);

    // construct and load
    dynaload(const std::string& library, const std::string& path = std::string());

    // unload if loaded and then destroy
    ~dynaload(void);

    // load the library - return success or fail
    bool load(const std::string& library, const std::string& path = std::string());

    // unload the library if loaded
    bool unload(void);

    // test whether the library is loaded
    bool loaded(void) const;

    ////////////////////////////////////////////////////////////////////////////
    // symbol management

    // test whether a function is exported by the library
    bool present(const std::string& name);

    // get the function as a generic pointer
    void* symbol(const std::string& name);

    ////////////////////////////////////////////////////////////////////////////
    // error management

    // enum values to indicate type of error
    enum error_t {no_error, load_error, unload_error, symbol_error};

    // test whether there has been an error
    bool error(void) const;

    // clear an error once it has been handled (or ignored)
    void clear_error(void);

    // get the type of the error as indicated by the enum error_t
    error_t error_type(void) const;

    // get the text of the error as provided by the OS
    std::string error_text(void) const;

    ////////////////////////////////////////////////////////////////////////////

  private:
    void* m_handle;
    error_t m_error;
    std::string m_text;
  };

}

#endif
