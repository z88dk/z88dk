/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.h,v 1.4 2014-01-11 01:29:40 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "list.h"
#include "strutil.h"
#include <stdio.h>
#include <sys/stat.h>

/* File name extension separator */
#ifdef QDOS
#define FILEEXT_SEPARATOR "_"
#else
#define FILEEXT_SEPARATOR "."
#endif

/*-----------------------------------------------------------------------------
*   Define a Str to hold a filename
*----------------------------------------------------------------------------*/
#define DEFINE_FILE_STR( name )		DEFINE_STR( name, FILENAME_MAX )

/*-----------------------------------------------------------------------------
*   Pathname manipulation
*   All filenames are returned in fixed length Str defined by
*	DEFINE_STR( dest, FILENAME_MAX ).
*	Input string is unchanged.
*	Basename is file name removing all directories.
*	Extension is the final "." followed by sequence of letters or digits
*----------------------------------------------------------------------------*/
extern void path_remove_ext( Str *dest, char *filename );
extern void path_replace_ext( Str *dest, char *filename, char *new_ext );
extern void path_basename( Str *dest, char *filename );

/* search for a file on the given directory list, return full path name */
extern void path_search( Str *dest, char *filename, List *dir_list );
extern char *search_file( char *filename, List *dir_list );	/* returned string in strpool */

/*-----------------------------------------------------------------------------
*   File input/output
*	Register callbacks to be used on fatal read/write of a file.
*	In case of error, functions call the registered call-back and then return
*	FALSE or NULL.
*----------------------------------------------------------------------------*/

/* set call-back for input/output error; return old call-back */
typedef void (*file_io_err_f)(char *filename);

extern file_io_err_f file_set_rerr_callback( file_io_err_f func );
extern file_io_err_f file_set_werr_callback( file_io_err_f func );


/*
* $Log: fileutil.h,v $
* Revision 1.4  2014-01-11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.3  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.2  2014/01/02 17:18:16  pauloscustodio
* StrList removed, replaced by List
*
* Revision 1.1  2014/01/01 21:23:49  pauloscustodio
* Move generic file utility functions to lib/fileutil.c
*
*
*/
