//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include <string>

// command line parsing
extern char* g_optarg;
extern int g_optind;
int simple_getopt(int argc, char* argv[], const char* optstring);

// options and global data
extern bool g_verbose;                          // true to show progress
extern bool g_keep_temp_files;                  // true to keep temporary files
extern std::vector<std::string> g_temp_files;   // temp files to delete on exit

#ifdef _DEBUG
extern int g_dump_step;                         // step to stop at
#endif
