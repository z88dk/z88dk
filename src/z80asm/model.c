/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Global data model.

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.c,v 1.11 2014-06-21 02:18:29 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

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
DEFINE_init()
{
	errors_init();						/* setup error handler */

	/* setup input handler */
	g_src_input = OBJ_NEW( SrcFile );
	set_new_line_cb( new_line_cb );
}

DEFINE_fini()
{
	OBJ_DELETE( g_src_input );
}

void model_init(void) 
{ 
	init(); 
}

/*-----------------------------------------------------------------------------
*   interface to SrcFile singleton
*----------------------------------------------------------------------------*/
void src_open( char *filename, List *dir_list )
{
	init();
	SrcFile_open( g_src_input, filename, dir_list );
}

char *src_getline( void )
{
	init();
	return SrcFile_getline( g_src_input );
}

void src_ungetline( char *lines )
{
	init();
	SrcFile_ungetline( g_src_input, lines );
}

char *src_filename( void )
{
	init();
	return SrcFile_filename( g_src_input );
}

int src_line_nr( void )
{
	init();
	return SrcFile_line_nr( g_src_input );
}

void src_push( void )
{
	init();
	SrcFile_push( g_src_input );
}

Bool src_pop( void )
{
	init();
	return SrcFile_pop( g_src_input );
}
