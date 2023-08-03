//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------

#pragma once

#include "types.h"
#include "strutil.h"
#include "utstring.h"

/* make library from source files; convert each source to object file name */
extern void make_library(const char *lib_filename);

// check if the given filename exists and is a library file of the correct version
extern bool check_library_file(const char *src_filename);
