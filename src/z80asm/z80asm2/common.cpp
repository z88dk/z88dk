//-----------------------------------------------------------------------------
// z80asm - reading of input files
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"

Assembler g_asm;
Errors g_errors;
vector<string> g_include_path;
vector<string> g_library_path;
bool g_verbose = false;
bool g_raw_strings = false;
bool g_upper_case = false;
cpu_t g_cpu = CPU_Z80;
swap_ixiy_t g_swap_ixiy = IXIY_NO_SWAP;
string g_output_dir;
string g_bin_filename;
