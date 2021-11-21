/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2021
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Assembly macros.
*/

#pragma once

typedef const char *(*getline_t)();

extern void init_macros();
extern void clear_macros();
extern void free_macros();
extern char *macros_getline(getline_t getline_func);

