/*
Z88DK Z80 Macro Assembler

Utilities working files.

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "types.h"
#include "str.h"
#include "utarray.h"
#include <stdio.h>

/* File name extension separator */
#ifdef QDOS
#define FILEEXT_SEPARATOR "_"
#else
#define FILEEXT_SEPARATOR "."
#endif

/*-----------------------------------------------------------------------------
*   File input/output
*	Register callbacks to be used on read/write error of a file.
*	Fatal error if number of chars read/writen not same as requested
*   Use fwrite/fread instead for checking.
*----------------------------------------------------------------------------*/
typedef void (*ferr_callback_t)(char *filename, Bool writing);

/* set call-back for input/output error; return old call-back */
extern ferr_callback_t set_ferr_callback( ferr_callback_t func );

/* OS interface */
extern FILE *myfopen( char *filename, char *mode );
extern void  myfclose( FILE *file );

/* open temp file for writing, rename to final name on myfclose()
   delete temp file by myfclose_remove() or atexit if xflcose() not called  */
extern FILE *myfopen_atomic( char *filename, char *mode );
extern void  myfclose_remove( FILE *file );

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
extern void    xfput_int8(  FILE *file, int  value );
extern void    xfput_uint8( FILE *file, Byte value );
extern int  xfget_int8(  FILE *file );
extern Byte xfget_uint8( FILE *file );

extern void     xfput_int16(  FILE *file, int  value );
extern void     xfput_uint16( FILE *file, int value );
extern int  xfget_int16(  FILE *file );
extern int xfget_uint16( FILE *file );

extern void     xfput_int32(  FILE *file, int  value );
extern void     xfput_uint32(FILE *file, unsigned int value);
extern int  xfget_int32(  FILE *file );
extern unsigned int xfget_uint32( FILE *file );

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
extern void path_search( Str *dest, char *filename, UT_array *dir_list );
extern char *search_file(char *filename, UT_array *dir_list);	/* returned string in strpool */

/* return a temp file name based on the given file: dirname(file).TEMP.basename(file) 
   all files with these names are deleted on exit */
extern char *temp_filename( char *filename );

/* check if file exists */
extern Bool file_exists(char *filename);
