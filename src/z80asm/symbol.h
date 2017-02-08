/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "expr.h"
#include "model.h"
#include "objfile.h"
#include "symtab.h"
#include "types.h"
#include "scan.h"
#include <stdlib.h>

/* Structured data types : */

enum flag           { OFF, ON };

struct liblist
{
    struct libfile    *firstlib;		/* pointer to first library file specified from command line */
    struct libfile    *currlib;			/* pointer to current library file specified from command line */
};

struct libfile
{
    struct libfile    *nextlib;			/* pointer to next library file in list */
    char              *libfilename;		/* filename of library (incl. extension) */
    long              nextobjfile;		/* file pointer to next object file in library */
};

struct linklist
{
    struct linkedmod  *firstlink;		/* pointer to first linked object module */
    struct linkedmod  *lastlink;		/* pointer to last linked module in list */
};

struct linkedmod
{
    struct linkedmod  *nextlink;		/* pointer to next module link */
    char              *objfilename;		/* filename of library/object file (incl. extension) */
    long              modulestart;		/* base pointer of beginning of object module */
    Module		     *moduleinfo;		/* pointer to main module information */
};
