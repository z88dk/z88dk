/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2019
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

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
extern bool  src_open(const char *filename, UT_array *dir_list );
extern char *src_getline( void );
extern void  src_ungetline(const char *lines );
extern const char *src_filename( void );
extern int   src_line_nr( void );	
extern bool  scr_is_c_source(void);

extern void src_set_filename(const char *filename);
extern void src_set_line_nr(int line_nr, int line_inc);
extern void src_set_c_source(void);

extern void  src_push( void );
extern bool  src_pop( void );
