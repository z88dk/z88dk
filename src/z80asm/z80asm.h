/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

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

extern size_t sizeof_relocroutine, sizeof_reloctable;

extern char *GetLibfile( char *filename );

extern void assemble_file( char *filename );
extern Bool Pass2info(range_t range);
extern Bool Pass2infoExpr(range_t range, Expr *expr);
