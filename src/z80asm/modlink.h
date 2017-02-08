/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "types.h"
#include "expr.h"

extern void link_modules( void );
extern void compute_equ_exprs( ExprList *exprs, Bool show_error, Bool module_relative_addr );
