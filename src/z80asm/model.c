/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Global data model.
*/

#include "model.h"
#include "codearea.h"
#include "errors.h"
#include "init.h"
#include "listfile.h"
#include "options.h"
#include "srcfile.h"

/*-----------------------------------------------------------------------------
*   Global data
*----------------------------------------------------------------------------*/
static SrcFile			*g_src_input;			/* input handle for reading source lines */

/*-----------------------------------------------------------------------------
*   Call-back called when reading each new line from source
*----------------------------------------------------------------------------*/
static void new_line_cb( char *filename, int line_nr, char *text )
{
    set_error_file( filename );		/* error file */

	if ( filename != NULL )
	{
        /* interface with error - set error location */
        if ( ! opts.line_mode )
            set_error_line( line_nr );

        /* interface with list */
        if ( opts.cur_list )
            list_start_line( get_PC(), filename, line_nr, text );
	}
	else
	{
		if ( ! opts.line_mode )
            set_error_line( 0 );
	}
}

/*-----------------------------------------------------------------------------
*   Initialize data structures
*----------------------------------------------------------------------------*/
DEFINE_init_module()
{
	errors_init();						/* setup error handler */

	/* setup input handler */
	g_src_input = OBJ_NEW( SrcFile );
	set_new_line_cb( new_line_cb );
}

DEFINE_dtor_module()
{
	OBJ_DELETE( g_src_input );
}

void model_init(void) 
{ 
	init_module(); 
}

/*-----------------------------------------------------------------------------
*   interface to SrcFile singleton
*----------------------------------------------------------------------------*/
Bool src_open(char *filename, UT_array *dir_list)
{
	init_module();
	return SrcFile_open( g_src_input, filename, dir_list );
}

char *src_getline( void )
{
	init_module();
	return SrcFile_getline( g_src_input );
}

void src_ungetline( char *lines )
{
	init_module();
	SrcFile_ungetline( g_src_input, lines );
}

char *src_filename( void )
{
	init_module();
	return SrcFile_filename( g_src_input );
}

int src_line_nr( void )
{
	init_module();
	return SrcFile_line_nr( g_src_input );
}

void src_push( void )
{
	init_module();
	SrcFile_push( g_src_input );
}

Bool src_pop( void )
{
	init_module();
	return SrcFile_pop( g_src_input );
}
