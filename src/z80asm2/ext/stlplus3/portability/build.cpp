////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

// report the platform-specific details of this build

////////////////////////////////////////////////////////////////////////////////
#include "build.hpp"
#include "version.hpp"
#include "dprintf.hpp"
////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  // STLplus version in the form "STLplus v3.0" - see version.hpp for a way of getting just the version number
  std::string stlplus_version(void)
  {
    return std::string("STLplus v") + version();
  }

  // calculate the word size dynamically by using the knowledge that ptrdiff_t is always a whole word
  int platform_bits(void)
  {
    return sizeof(std::ptrdiff_t) * 8;
  }

  // platform name is the target operating system in the form "Windows" or "Posix"
  std::string platform_name(void)
  {
#if defined _WIN64 || defined _WIN32
    return std::string("Windows");
#elif defined __CYGWIN__
    return std::string("Cygwin");
#elif defined __gnu_linux__
    return std::string("GNU/Linux");
#elif defined __FreeBSD__
    return std::string("FreeBSD");
#else
    // at present there are no distinctions made between other different Unix platforms so
    // they all map onto the generic platform
    return std::string("Posix");
#endif
  }

  // platform is the target operating system and its bit size in the form "Windows 32-bit" or "Generic 64-bit"
  std::string platform(void)
  {
    return dformat("%s %d-bit", platform_name().c_str(), platform_bits());
  }

  // compiler_name is the short name of the compiler, e.g. "gcc" or "MSVC"
  std::string compiler_name(void)
  {
#if defined __GNUC__
    return std::string("gcc");
#elif defined _MSC_VER
    return std::string("MSVC");
#elif defined __BORLANDC__
    return std::string("Borland");
#else
    return std::string("unknown compiler");
#endif
  }

  // compiler_version is the version string of the compiler e.g. "3.4" for gcc or "15.00" for MSVC
  std::string compiler_version(void)
  {
#if defined __GNUC__
    return dformat("%d.%d.%d",__GNUC__,__GNUC_MINOR__,__GNUC_PATCHLEVEL__);
#elif defined _MSC_VER
    return dformat("%0.2f",((float)_MSC_VER)/100.0);
#elif defined __BORLANDC__
    return dformat("%d.%d%d",__BORLANDC__/256,__BORLANDC__/16%16,__BORLANDC__%16);
#else
    return std::string("?.?");
#endif
  }

  // compiler is the compilation system and version above combined into a human-readable form e.g. "gcc v3.4"
  std::string compiler(void)
  {
    return compiler_name() + std::string(" v") + compiler_version();
  }

  // variant is the kind of build - "debug" or "release"
  std::string variant(void)
  {
#ifndef NDEBUG
    return std::string("debug");
#else
    return std::string("release");
#endif

  }

  // a string containing all the information
  std::string build(void)
  {
    return stlplus_version() + ", " + platform() + ", " + compiler() + ", " + variant();
  }

////////////////////////////////////////////////////////////////////////////////
} // end namespace stlplus
