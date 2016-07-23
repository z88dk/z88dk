//-----------------------------------------------------------------------------
// Global data
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef GLOBAL_HPP
#define GLOBAL_HPP

#include <string>
#include <vector>

// program path and name
extern std::string g_prog_folder;		// directory from which main() was started
extern std::string g_prog_basename;		// program name without .exe extension

// init globals dependent on argv[0]
extern void init_global(const std::string& argv0);

// global args produced by cmdline parsing
struct args_t
{
	bool	is_verbose;					// -v, --verbose
	std::vector<std::string> inc_path;	// list of directories to search for source files, option -I, --inc-path
	std::vector<std::string> lib_path;	// list of directories to search for library files, option -L, --lib-path
	std::vector<std::string> files;		// list of input files, with '@' lists already expanded
};

extern args_t g_args;

#endif /* ndef GLOBAL_HPP */
