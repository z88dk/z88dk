////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "dynaload.hpp"
#include "file_system.hpp"
#include <iostream>

#ifdef MSWINDOWS
#include <windows.h>
#else
#include <dlfcn.h>
#endif

////////////////////////////////////////////////////////////////////////////////

#ifdef MSWINDOWS

static std::string last_error(void)
{
  // get the last error code - if none, return the empty string
  DWORD err = GetLastError();
  if (err == 0) return std::string();
  // get the system message for this error code
  char* message;
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS,
                0,
                err,
                MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                (LPTSTR)&message,
                0,0);
  std::string result = message;
  LocalFree(message);
  // the error message is for some perverse reason newline terminated - remove this
  if (result[result.size()-1] == '\n')
    result.erase(result.end()-1);
  if (result[result.size()-1] == '\r')
    result.erase(result.end()-1);
  return result;
}

#else

static std::string last_error(void)
{
  return std::string(dlerror());
}

#endif

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // library management

  // construct the object but do not load
  dynaload::dynaload(void) : m_handle(0), m_error(no_error)
  {
  }

  // construct and load
  dynaload::dynaload(const std::string& library, const std::string& path) : m_handle(0)
  {
    load(library, path);
  }

  // destroy and unload if loaded
  dynaload::~dynaload(void)
  {
    unload();
  }

  // load the library - return success or fail
  bool dynaload::load(const std::string& library, const std::string& path)
  {
#ifdef MSWINDOWS
    // naming convention is <name>.dll
    std::string library_name = library;
#else
    // naming convention is lib<name>.so
    // TODO - does this work with versioned libraries?
    std::string library_name = std::string("lib") + library + std::string(".so");
#endif
    std::string library_filespec = stlplus::create_filespec(path, library_name);
    std::cerr << "library name " << library_filespec << std::endl;
#ifdef MSWINDOWS
    // load a Windows DLL
    m_handle = (void*)LoadLibraryA(library_filespec.c_str());
#else
    // load a Posix shared library
    m_handle = dlopen(library_filespec.c_str(),RTLD_NOW);
#endif
    if (!m_handle)
    {
      m_error = load_error;
      m_text = library_filespec + " - " + last_error();
    }
    return loaded();
  }

  // unload the library if loaded
  bool dynaload::unload(void)
  {
    if (!loaded()) return false;
#ifdef MSWINDOWS
    int status = FreeLibrary((HINSTANCE)m_handle) ? 0 : 1;
#else
    int status = dlclose(m_handle);
#endif
    if (status != 0)
    {
      m_error = unload_error;
      m_text = last_error();
    }
    return status == 0;
  }

  // test whether the library is loaded
  bool dynaload::loaded(void) const
  {
    return m_handle != 0;
  }

  ////////////////////////////////////////////////////////////////////////////
  // symbol management

  // test whether a function is exported by the library
  // does not set the error flag if fails
  bool dynaload::present(const std::string& name)
  {
    if (!loaded()) return false;
#ifdef MSWINDOWS
    void* fn = (void*)GetProcAddress((HINSTANCE)m_handle,name.c_str());
#else
    void* fn = dlsym(m_handle,name.c_str());
#endif
    return fn != 0;
  }

  // get the function as a generic pointer
  void* dynaload::symbol(const std::string& name)
  {
    if (!loaded()) return 0;
#ifdef MSWINDOWS
    void* fn = (void*)GetProcAddress((HINSTANCE)m_handle,name.c_str());
#else
    void* fn = dlsym(m_handle,name.c_str());
#endif
    if (!fn)
    {
      m_error = symbol_error;
      m_text = name + ": " + last_error();
    }
    return fn;
  }

  ////////////////////////////////////////////////////////////////////////////
  // error management

  // test whether there has been an error
  bool dynaload::error(void) const
  {
    return m_error != no_error;
  }

  // clear an error once it has been handled (or ignored)
  void dynaload::clear_error(void)
  {
    m_error = no_error;
    m_text = std::string();
  }

  // get the type of the error as indicated by the enum error_t
  dynaload::error_t dynaload::error_type(void) const
  {
    return m_error;
  }

  // get the text of the error as provided by the OS
  std::string dynaload::error_text(void) const
  {
    return m_text;
  }


////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
