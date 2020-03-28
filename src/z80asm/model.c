/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2019
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Global data model.
*/

#include "model.h"
#include "codearea.h"
#include "errors.h"
#include "init.h"
#include "macros.h"
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
static void new_line_cb(const char *filename, int line_nr, const char *text )
{
    set_error_file( filename );		/* error file */

	if ( filename != NULL )
	{
		/* interface with error - set error location */
		set_error_line(line_nr);
		
        /* interface with list */
		if (opts.cur_list)
			list_start_line(get_phased_PC() >= 0 ? get_phased_PC() : get_PC(), filename, line_nr, text);
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
bool src_open(const char *filename, UT_array *dir_list)
{
	init_module();
	return SrcFile_open( g_src_input, filename, dir_list );
}

static char *src_getline1( void )
{
	init_module();
	return SrcFile_getline( g_src_input );
}

char *src_getline()
{
	return macros_getline(src_getline1);
}

void src_ungetline(const char *lines )
{
	init_module();
	SrcFile_ungetline( g_src_input, lines );
}

const char *src_filename( void )
{
	init_module();
	return SrcFile_filename( g_src_input );
}

int src_line_nr( void )
{
	init_module();
	return SrcFile_line_nr( g_src_input );
}

bool scr_is_c_source(void)
{
	init_module();
	return ScrFile_is_c_source(g_src_input);
}

void src_set_filename(const char * filename)
{
	init_module();
	SrcFile_set_filename(g_src_input, filename);
}

void src_set_line_nr(int line_nr, int line_inc)
{
	init_module();
	SrcFile_set_line_nr(g_src_input, line_nr, line_inc);
}

void src_set_c_source(void)
{
	init_module();
	SrcFile_set_c_source(g_src_input);
}

void src_push( void )
{
	init_module();
	SrcFile_push( g_src_input );
}

bool src_pop( void )
{
	init_module();
	return SrcFile_pop( g_src_input );
}
