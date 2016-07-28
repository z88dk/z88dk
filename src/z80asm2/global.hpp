//-----------------------------------------------------------------------------
// Global data
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef GLOBAL_HPP
#define GLOBAL_HPP

#include <string>
#include <vector>
#include "module.hpp"

// init globals dependent on argv[0]
extern void init_global(const std::string& argv0);

// program path and name
extern std::string g_prog_folder;			// directory from which main() was started
extern std::string g_prog_basename;			// program name without .exe extension

// global args produced by cmdline parsing
struct args_t
{
	args_t()
		: asm_extension("asm")				// TODO: may be redefined with -e, --asm-ext
		, obj_extension("obj") {}			// TODO: may be redefined with -M, --obj-ext

	std::string	asm_extension;	
	std::string	obj_extension;

	bool		is_verbose;					// -v, --verbose

	std::vector<std::string> inc_path;		// TODO: list of directories to search for source files, option -I, --inc-path
	std::vector<std::string> lib_path;		// TODO: list of directories to search for library files, option -L, --lib-path
	std::vector<std::string> files;			// list of input files, with '@' lists already expanded
	std::vector<Module>		 obj_modules;	// list of assembled modules
	std::vector<Module>		 lib_modules;	// TODO: list of modules linked from libraries during link phase
};

extern args_t g_args;

#endif /* ndef GLOBAL_HPP */
