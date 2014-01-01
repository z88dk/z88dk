/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.h,v 1.1 2014-01-01 21:23:49 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "strlist.h"
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
extern void path_remove_ext ( Str *dest, char *filename );
extern void path_replace_ext( Str *dest, char *filename, char *new_ext );
extern void path_basename   ( Str *dest, char *filename );

/* search for a file on the given directory list, return full path name */
extern void path_search( Str *dest, char *filename, StrList *dir_list );
extern char *search_file( char *filename, StrList *dir_list );	/* in strpool */

/*
* $Log: fileutil.h,v $
* Revision 1.1  2014-01-01 21:23:49  pauloscustodio
* Move generic file utility functions to lib/fileutil.c
*
*
*/
