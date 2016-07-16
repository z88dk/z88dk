#ifndef STLPLUS_PERSISTENCE_FIXES
#define STLPLUS_PERSISTENCE_FIXES
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Contains work arounds for OS or Compiler specific problems

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Unnecessary compiler warnings
////////////////////////////////////////////////////////////////////////////////

// Microsoft Visual Studio
#ifdef _MSC_VER
// shut up the following irritating warnings
//   4786 - VC6, identifier string exceeded maximum allowable length and was truncated (only affects debugger)
//   4305 - VC6, identifier type was converted to a smaller type
//   4503 - VC6, decorated name was longer than the maximum the compiler allows (only affects debugger)
//   4309 - VC6, type conversion operation caused a constant to exceeded the space allocated for it
//   4290 - VC6, C++ exception specification ignored
//   4800 - VC6, forcing value to bool 'true' or 'false' (performance warning)
//   4675 - VC7.1, "change" in function overload resolution _might_ have altered program
//   4996 - VC8, 'xxxx' was declared deprecated
#pragma warning(disable: 4786 4305 4503 4309 4290 4800 4675 4996)
#endif

// Borland
#ifdef __BORLANDC__
// Shut up the following irritating warnings
//   8026 - Functions with exception specifications are not expanded inline
//   8027 - Functions with xxx are not expanded inline
#pragma warn -8026
#pragma warn -8027
#endif

////////////////////////////////////////////////////////////////////////////////
// Rules for testing whether this compiler has C++11 extension data types (especially shared_ptr)
// Specifically I only support use of these extensions in their final, standard form
// I don't support the TR1 proposed versions which put headers in a
// tr1/ subdirectory and components in a std::tr1 sub-namespace
////////////////////////////////////////////////////////////////////////////////

// gcc
// in normal mode, the extensions are not supported
// However, gcc has a C++11 mode and then they are supported
// C++11 mode is switched on from the command line using the -std=c++11 flag and that sets the following macro
#if defined(__GNUC__) && (__cplusplus > 201100)
#define STLPLUS_HAS_CXX11 1
#endif

// Visual Studio
// Microsoft only incorporated the extensions in their C++11 form from Visual Studio 2010 (v16.00)
#if defined(_MSC_VER) && (_MSC_VER >= 1600)
#define STLPLUS_HAS_CXX11 1
#endif

// Borland
// Borland use an old version of Dinkumware's library which doesn't have of the C++11 features (as of v6.31)
// Add support as soon as it becomes available which I think is Dinkumware v505
#if defined(__BORLANDC__) && (__BORLANDC__ >= 0x631)
#include <yvals.h>
#if defined(_CPPLIB_VER) && (_CPPLIB_VER >= 505)
#define STLPLUS_HAS_CXX11 1
#endif
#endif

////////////////////////////////////////////////////////////////////////////////
#endif
