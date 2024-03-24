//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"

Errors g_errors;
vector<string> g_include_path;
vector<string> g_library_path;
