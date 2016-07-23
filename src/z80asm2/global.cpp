//-----------------------------------------------------------------------------
// Global data
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "global.hpp"
#include "file_system.hpp"

// global args produced by cmdline parsing
args_t g_args;

// program path and name
std::string g_prog_folder;			// directory from which main() was started
std::string g_prog_basename;		// program name without .exe extension

// init globals dependent on argv[0]
void init_global(const std::string& argv0)
{
	// progname
	g_prog_folder = stlplus::install_path(argv0);
	g_prog_basename = stlplus::basename_part(argv0);
}

