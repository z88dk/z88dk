////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

#include "debug.hpp"
#include "dprintf.hpp"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  static std::string format(const char* file, int line, const char* function, const char* message)
  {
    return dformat("%s:%d:%s: assertion failed: %s",
                   (file ? file : ""),
                   line,
                   (function ? function : "") ,
                   (message ? message : ""));
  }

  ////////////////////////////////////////////////////////////////////////////////

  assert_failed::assert_failed(const char* file, int line, const char* function, const char* message)
    throw() : 
    std::logic_error(format(file, line, function, message))
  {
  }

  assert_failed::~assert_failed(void) throw()
  {
  }

  ////////////////////////////////////////////////////////////////////////////////

  static unsigned _debug_depth = 0;
  static bool _debug_global = false;
  static bool _debug_set = false;
  static bool _debug_recurse = false;
  static bool _debug_read = false;
  static char* _debug_match = 0;
  static const debug_trace* debug_last = 0;

  void debug_global(const char* file, int line, const char* function, bool state)
  {
    _debug_global = state;
    fprintf(stderr, "%s:%i:[%i]%s ", file, line, _debug_depth, function ? function : "");
    fprintf(stderr, "debug global : %s\n", _debug_global ? "on" : "off");
  }

  void debug_assert_fail(const char* file, int line, const char* function, const char* test) 
    throw(assert_failed)
  {
    fprintf(stderr, "%s:%i:[%i]%s: assertion failed: %s\n", 
            file, line, _debug_depth, function ? function : "", test);
    if (debug_last) debug_last->stackdump();
    throw assert_failed(file, line, function, test);
  }

  ////////////////////////////////////////////////////////////////////////////////

  debug_trace::debug_trace(const char* f, int l, const char* fn) :
    m_file(f), m_line(l), m_function(fn ? fn : ""), 
    m_depth(0), m_last(debug_last), m_dbg(false), m_old(false)
  {
    if (!_debug_read)
    {
      _debug_match = getenv("DEBUG");
      _debug_recurse = getenv("DEBUG_LOCAL") == 0;
      _debug_read = true;
    }
    m_dbg = _debug_set || (_debug_match && (!_debug_match[0] || (strcmp(_debug_match, m_file) == 0)));
    m_old = _debug_set;
    if (m_dbg && _debug_recurse)
      _debug_set = true;
    m_depth = ++_debug_depth;
    debug_last = this;
    if (debug()) report(std::string("entering ") + (m_function ? m_function : ""));
  }

  debug_trace::~debug_trace(void)
  {
    if (debug()) report("leaving");
    --_debug_depth;
    _debug_set = m_old;
    debug_last = m_last;
  }

  const char* debug_trace::file(void) const
  {
    return m_file;
  }

  int debug_trace::line(void) const
  {
    return m_line;
  }

  bool debug_trace::debug(void) const
  {
    return m_dbg || _debug_global;
  }

  void debug_trace::debug_on(int l, bool recurse)
  {
    m_dbg = true;
    m_old = _debug_set;
    if (recurse)
      _debug_set = true;
    report(l, std::string("debug on") + (recurse ? " recursive" : ""));
  }

  void debug_trace::debug_off(int l)
  {
    if (debug()) report(l, std::string("debug off"));
    m_dbg = false;
    _debug_set = m_old;
  }

  void debug_trace::prefix(int l) const
  {
    fprintf(stderr, "%s:%i:[%i]%s ", m_file, l, m_depth, m_function ? m_function : "");
  }

  void debug_trace::do_report(int l, const std::string& message) const
  {
    prefix(l);
    fprintf(stderr, "%s\n", message.c_str());
    fflush(stderr);
  }

  void debug_trace::do_report(const std::string& message) const
  {
    do_report(m_line, message);
  }

  void debug_trace::report(int l, const std::string& message) const
  {
    do_report(l, message);
  }

  void debug_trace::report(const std::string& message) const
  {
    report(m_line, message);
  }

  void debug_trace::error(int l, const std::string& message) const
  {
    do_report(l, "ERROR: " + message);
  }

  void debug_trace::error(const std::string& message) const
  {
    error(m_line, message);
  }

  void debug_trace::stackdump(int l, const std::string& message) const
  {
    do_report(l, message);
    stackdump();
  }

  void debug_trace::stackdump(const std::string& message) const
  {
    stackdump(m_line, message);
  }

  void debug_trace::stackdump(void) const
  {
    for (const debug_trace* item = this; item; item = item->m_last)
      item->do_report("...called from here");
  }


  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
