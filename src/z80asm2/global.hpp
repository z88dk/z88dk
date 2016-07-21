//-----------------------------------------------------------------------------
// Global data
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef GLOBAL_HPP
#define GLOBAL_HPP

#include <string>

// program path and name
extern std::string g_prog_folder;		// directory from which main() was started
extern std::string g_prog_basename;		// program name without .exe extension

// init globals dependent on argv[0]
extern void init_global(const std::string& argv0);

#endif /* ndef GLOBAL_HPP */
