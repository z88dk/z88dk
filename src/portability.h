// Portability defines for building z88dk
#pragma once

#include <stdio.h>			// needed before vsnprintf macro

// strcasecmp()
#if defined(_WIN32) || defined(WIN32)
#define strcasecmp(a,b) stricmp(a,b)
#endif

// snprintf()
#ifdef _MSC_VER
#define snprintf _snprintf
#define vsnprintf _vsnprintf
#endif

// glob()
#if defined(_WIN32) || defined(WIN32)
#include <unixem/glob.h>
#endif
#include <glob.h>

// OSX does not have GLOB_ONLYDIR
#ifndef GLOB_ONLYDIR
#define GLOB_ONLYDIR 0
#endif

#ifdef _MSC_VER
#define __NORETURN
#endif
