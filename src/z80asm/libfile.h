/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Handle library file contruction, reading and writing
*/

#pragma once

#include "utarray.h"

extern char Z80libhdr[];

/* make library from list of files; convert each source to object file name */
extern void make_library(char *lib_filename, UT_array *src_files);
