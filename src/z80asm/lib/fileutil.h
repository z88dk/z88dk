/*
Utilities working files.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/fileutil.h,v 1.15 2014-05-17 14:27:13 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "list.h"
#include "strutil.h"
#include "types.h"

#include <stdio.h>

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
*   File input/output
*	Register callbacks to be used on fatal read/write of a file.
*	Fatal error if number of chars read/writen not same as requested
*   Use fwrite/fread instead for checking.
*----------------------------------------------------------------------------*/
typedef void (*ferr_callback_t)(char *filename, BOOL writing);

/* set call-back for input/output error; return old call-back */
extern ferr_callback_t set_ferr_callback( ferr_callback_t func );

/* OS interface with fatal errors on failure */
extern FILE *xfopen( char *filename, char *mode );
extern void  xfclose( FILE *file );

/* open temp file for writing, rename to final name on xfclose()
   delete temp file by xfclose_remove() or atexit if xflcose() not called  */
extern FILE *xfopen_atomic( char *filename, char *mode );
extern void  xfclose_remove( FILE *file );

/* read/write buffers */
extern void xfwrite( void *buffer, size_t size, size_t count, FILE *file );
extern void xfread(  void *buffer, size_t size, size_t count, FILE *file );

/* read/write strings of characters */
extern void xfput_chars( FILE *file, char *buffer, size_t len );
extern void xfget_chars( FILE *file, char *buffer, size_t len );

/* read/write Str */
extern void xfput_strz( FILE *file, char *str );
extern void xfput_Str(  FILE *file, Str  *str );
extern void xfget_Str(  FILE *file, Str  *str, size_t len );

/* read/write counted string - string with size byte/word at start */
extern void xfput_count_byte_strz( FILE *file, char *str );
extern void xfput_count_byte_Str(  FILE *file, Str  *str );
extern void xfget_count_byte_Str(  FILE *file, Str  *str );

extern void xfput_count_word_strz( FILE *file, char *str );
extern void xfput_count_word_Str(  FILE *file, Str  *str );
extern void xfget_count_word_Str(  FILE *file, Str  *str );

/* read/write numbers */
extern void    xfput_int8(  FILE *file, int8_t  value );
extern void    xfput_uint8( FILE *file, uint8_t value );
extern int8_t  xfget_int8(  FILE *file );
extern uint8_t xfget_uint8( FILE *file );

extern void     xfput_int16(  FILE *file, int16_t  value );
extern void     xfput_uint16( FILE *file, uint16_t value );
extern int16_t  xfget_int16(  FILE *file );
extern uint16_t xfget_uint16( FILE *file );

extern void     xfput_int32(  FILE *file, int32_t  value );
extern void     xfput_uint32( FILE *file, uint32_t value );
extern int32_t  xfget_int32(  FILE *file );
extern uint32_t xfget_uint32( FILE *file );

/*-----------------------------------------------------------------------------
*   Pathname manipulation
*   All filenames are returned in strpool
*	Input string is unchanged.
*	Basename is file name removing all directories.
*	Dirname is the path up to and including the final slash.
*	Extension is the final "." followed by sequence of letters or digits
*----------------------------------------------------------------------------*/
extern char *path_remove_ext( char *filename );
extern char *path_replace_ext( char *filename, char *new_ext );
extern char *path_basename( char *filename );
extern char *path_dirname( char *filename );

/* search for a file on the given directory list, return full path name */
extern void path_search( Str *dest, char *filename, List *dir_list );
extern char *search_file( char *filename, List *dir_list );	/* returned string in strpool */

/* return a temp file name based on the given file: dirname(file).TEMP.basename(file) 
   all files with these names are deleted on exit */
extern char *temp_filename( char *filename );

/*
* $Log: fileutil.h,v $
* Revision 1.15  2014-05-17 14:27:13  pauloscustodio
* Use C99 integer types int8_t, uint8_t, int16_t, uint16_t, int32_t, uint32_t
*
* Revision 1.14  2014/05/06 22:17:38  pauloscustodio
* Made types uint8_t, uint32_t all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.13  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to uint8_t, uint32_t
*
* Revision 1.12  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.11  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint32_t, use uint32_t instead of size_t.
*
* Revision 1.10  2014/02/02 23:00:54  pauloscustodio
* New xfclose_remove() to remove file after closing.
*
* Revision 1.9  2014/01/29 22:40:52  pauloscustodio
* Mechanism for atomic file write - open a temp file for writing on
* xfopen_atomic(), close and rename to final name on xfclose().
* temp_filename() to generate a temporary file name that is
* deleted atexit.
*
* Revision 1.8  2014/01/21 23:12:30  pauloscustodio
* path_... functions return filename instrpool, no need to pass an array to store result.
*
* Revision 1.7  2014/01/21 22:42:18  pauloscustodio
* New dirname(), temp_filename()
*
* Revision 1.6  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.5  2014/01/15 00:01:40  pauloscustodio
* Decouple file.c from errors.c by adding a call-back mechanism in file for
* fatal errors, setup by errors_init()
*
* Revision 1.4  2014/01/11 01:29:40  pauloscustodio
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
