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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/model.c,v 1.10 2014-06-13 19:14:04 pauloscustodio Exp $
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


/*
* $Log: model.c,v $
* Revision 1.10  2014-06-13 19:14:04  pauloscustodio
* Move module list to module.c
*
* Revision 1.9  2014/06/09 13:30:28  pauloscustodio
* Rename current module abrev
*
* Revision 1.8  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.7  2014/05/02 21:00:49  pauloscustodio
* Hide module list, expose only iterators on CURRENTMODULE
*
* Revision 1.6  2014/05/02 20:24:38  pauloscustodio
* New class Module to replace struct module and struct modules
*
* Revision 1.5  2014/03/16 19:19:49  pauloscustodio
* Integrate use of srcfile in scanner, removing global variable z80asmfile
* and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
*
* Revision 1.4  2014/03/15 14:35:51  pauloscustodio
* Add interface to lookup current file name and line number
*
* Revision 1.3  2014/02/08 18:30:49  pauloscustodio
* lib/srcfile.c to read source files and handle recursive includes,
* used to read @lists, removed opts.files;
* model.c to hold global data model
*
*
*/
