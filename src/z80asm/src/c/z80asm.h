/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#pragma once

#include "if.h"
#include "types.h"
#include "sym.h"
#include "expr.h"
#include <stdio.h>
#include <stdlib.h>

#ifdef MSDOS
#define MAXCODESIZE 65532       /* MSDOS 64K heap boundary */
#else
#define MAXCODESIZE 65536
#endif

extern size_t sizeof_reloctable;

extern void assemble_file( const char *filename );
extern bool Pass2info(range_t range);
extern bool Pass2infoExpr(range_t range, Expr *expr);
