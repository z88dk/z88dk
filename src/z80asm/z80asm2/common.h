//-----------------------------------------------------------------------------
// z80asm - global data
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "z80asm_defs.h"
#include <string>
#include <vector>
using namespace std;

// errors
extern Errors g_errors;

// include and library path
extern vector<string> g_include_path;       // -I option
extern vector<string> g_library_path;       // -L option

// options
extern bool g_raw_strings;                  // -raw-strings option
extern bool g_upper_case;                   // -ucase option
extern swap_ixiy_t g_swap_ixiy;             // -IXIY option
