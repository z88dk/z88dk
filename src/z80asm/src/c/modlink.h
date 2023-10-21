/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#pragma once

#include "types.h"
#include "expr1.h"
#include "module1.h"
#include "utlist.h"

// append a library from the command line to the list to be linked
void library_file_append(const char* filename);

// append an object from the command line to the list to be linked
bool object_file_check_append(const char* filename, Module1* module, bool reserve_space, bool no_errors);
void object_file_append(const char* filename, Module1* module);

void link_modules(void);
void compute_equ_exprs(Expr1List *exprs, bool show_error, bool module_relative_addr);

// call appmake if required by command line
void checkrun_appmake(void);
