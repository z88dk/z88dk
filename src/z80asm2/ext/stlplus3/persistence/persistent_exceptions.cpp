////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

#include "persistent_exceptions.hpp"
#include <stdio.h>

////////////////////////////////////////////////////////////////////////////////

static std::string to_string(int number)
{
  // use sprintf in a very controlled way that cannot overrun
  char* buffer = new char[50];
  sprintf(buffer, "%i", number);
  std::string result = buffer;
  delete[] buffer;
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// exceptions

stlplus::persistent_illegal_type::persistent_illegal_type(const std::string& type) throw() : 
  std::logic_error(std::string("illegal type: ") + type)
{
}

stlplus::persistent_illegal_type::persistent_illegal_type(unsigned key) throw() : 
  std::logic_error(std::string("illegal key: ") + to_string((int)key))
{
}

stlplus::persistent_illegal_type::~persistent_illegal_type(void) throw()
{
}

////////////////////////////////////////////////////////////////////////////////

stlplus::persistent_dump_failed::persistent_dump_failed(const std::string& message) throw() :
  std::runtime_error(std::string("dump failed: ") + message)
{
}

stlplus::persistent_dump_failed::~persistent_dump_failed(void) throw()
{
}

////////////////////////////////////////////////////////////////////////////////

stlplus::persistent_restore_failed::persistent_restore_failed(const std::string& message) throw() :
  std::runtime_error(std::string("restore failed: ") + message)
{
}

stlplus::persistent_restore_failed::~persistent_restore_failed(void) throw()
{
}

////////////////////////////////////////////////////////////////////////////////
