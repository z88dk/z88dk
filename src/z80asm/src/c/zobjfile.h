/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Handle object file contruction, reading and writing
*/

#pragma once

#include "array.h"
#include "class.h"
#include "if.h"
#include "module1.h"
#include "types.h"
#include "if.h"
#include "z80asm_defs.h"
#include <stdio.h>
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   Write current module to object file - object file name is computed
*----------------------------------------------------------------------------*/
extern void write_obj_file(const char* src_filename);

/*-----------------------------------------------------------------------------
*   Module1 interface to object files
*----------------------------------------------------------------------------*/

/* Updates current module name and size, if object file of given source is valid
   load module name and size, when assembling with -d and up-to-date */
extern bool objmodule_loaded(const char* obj_filename);

// check if the given filename exists and is an object file of the correct version
extern bool check_object_file(const char* obj_filename);
extern bool check_object_file_no_errors(const char* obj_filename);

// worker
extern bool check_obj_lib_file(
    bool is_lib,
    const char* filename,
	const char* signature,
    void(*do_error_file_not_found)(const char*),
    void(*do_error_file_open)(const char*),
	void(*do_error_file_type)(const char*),
	void(*do_error_version)(const char*, int, int),
    void(*do_error_cpu_incompatible)(const char*, cpu_t),
    void(*do_error_ixiy_incompatible)(const char*, swap_ixiy_t));
