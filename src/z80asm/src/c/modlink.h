/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#pragma once

#include "types.h"
#include "expr.h"
#include "module.h"
#include "utlist.h"

// append a library from the command line to the list to be linked
bool library_file_append(const char* filename);

// append an object from the command line to the list to be linked
bool object_file_append(const char* filename, Module* module, bool reserve_space, bool no_errors);

void link_modules(void);
void compute_equ_exprs(ExprList *exprs, bool show_error, bool module_relative_addr);
