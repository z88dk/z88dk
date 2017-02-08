/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Global data model.
*/

#pragma once

#include "list.h"
#include "module.h"
#include "types.h"
#include "utarray.h"



/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
extern void model_init(void);

/*-----------------------------------------------------------------------------
*   Singleton interfaces
*----------------------------------------------------------------------------*/

/* interface to SrcFile singleton */
extern Bool  src_open( char *filename, UT_array *dir_list );
extern char *src_getline( void );
extern void  src_ungetline( char *lines );
extern char *src_filename( void );
extern int   src_line_nr( void );	

extern void  src_push( void );
extern Bool  src_pop( void );
