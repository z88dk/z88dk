#ifndef STLPLUS_BUILD
#define STLPLUS_BUILD
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Provides a printable representation of the build characteristics in the form:

//     version, platform, compiler, variant

//   Where
//     version is the version of STLplus
//     platform is the target operating system
//     compiler is the compilation system and version that the function was compiled with
//     variant is the kind of build - debug or release

//   Example:
//     STLplus version 3.0, Generic Unix, gcc v3.4, debug

////////////////////////////////////////////////////////////////////////////////
#include "portability_fixes.hpp"
#include <string>

namespace stlplus
{

  // STLplus version in the form "STLplus version 3.0" - see version.hpp for a way of getting just the version number
  std::string stlplus_version(void);

  // platform is the target operating system in the form "Windows" or "Generic Unix"
  std::string platform(void);

  // compiler_name is the short name of the compiler, e.g. "gcc" or "MSVC"
  std::string compiler_name(void);
  // compiler_version is the version string of the compiler e.g. "3.4" for gcc or "15.00" for MSVC
  std::string compiler_version(void);
  // compiler is the compilation system and version above combined into a human- readable form e.g. "gcc v3.4"
  std::string compiler(void);

  // variant is the kind of build - "debug" or "release"
  std::string variant(void);

  // build is all of the above combined into a human-readable string
  std::string build(void);

}
////////////////////////////////////////////////////////////////////////////////
#endif
