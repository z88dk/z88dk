/*
Z88DK Z80 Macro Assembler

Dynamic strings

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include "alloc.h"
#include "dbg.h"
#include <stdio.h>
#include <stdarg.h>

#ifndef va_copy
#define va_copy(dst, src)  ((void)((dst) = (src)))
#endif

/*-----------------------------------------------------------------------------
*   Utilities working on char *
*----------------------------------------------------------------------------*/

/* convert string to upper/lower case - modify in place,
   return address of string */
extern char *stoupper(char *str);
extern char *stolower(char *str);

/* case insensitive compare */
extern int stricompare(char *str1, char *str2);

/* remove end newline and whitespace - modify in place, return address of string */
extern char *chomp(char *str);

/* remove begin and end whitespace - modify in place, return address of string */
extern char *strip(char *str);

/* convert C-escape sequences - modify in place, return final length
   to allow strings with '\0' characters
   Accepts \b, \f, \n, \r, \t, \v, \xhh, \? \ooo */
extern int compress_escapes(char *str);

/*-----------------------------------------------------------------------------
*   Str structure
*----------------------------------------------------------------------------*/
typedef struct _Str {
	char   *data;				/* point at string data */
	int 	len;				/* length of string */
	int		size;				/* size of allocated buffer > len to allow for '\0' */
	struct {
		Bool	header_alloc : 1;	/* true if header is allocated in the heap */
		Bool	data_alloc   : 1;	/* true if data is allocated in the heap
									   and can be reallocated and freed */
	} flag;
} Str;

/*-----------------------------------------------------------------------------
*   declare and define an initialized Str * as global or static variable
*	if string is expanded, data is copied to a malloc'ed area
*	use STR_DELETE at the end of functions having STR_DEFINE to free
*	that memory
*----------------------------------------------------------------------------*/
#define STR_DECLARE( name )			Str *name

#define STR_DEFINE( name, size )	struct { \
										char data[ (size) ]; \
										Str  str; \
									} _##name##_data = { \
										"", \
										{ _##name##_data.data, 0, (size), \
										  { FALSE, FALSE } } \
									}; \
									Str *name = & _##name##_data.str

#define STR_DELETE( name )			str_delete( name )

#ifndef STR_SIZE
#define STR_SIZE					MAX(256, FILENAME_MAX)	/* default string size */
#endif

/*-----------------------------------------------------------------------------
*   Accessors
*----------------------------------------------------------------------------*/
#define str_data( str )				( (str)->data )
#define str_len( str )				( (str)->len )
#define str_size( str )				( (str)->size )

/*-----------------------------------------------------------------------------
*   initialize and delete
*----------------------------------------------------------------------------*/

/* allocate a Str on the heap and return pointer; die on error */
extern Str *str_new_(int size);
#define     str_new( size )			(check_ptr_die(str_new_(size), != NULL, "str_new failed" ))

/* free a string */
extern void str_delete_(Str *str);
#define     str_delete( str )		(str_delete_(str), (str) = NULL)

/* reserve space for at least more size chars plus '\0'
   does nothing if buffer is already large enough */
extern void str_reserve(Str *str, int size);

/*-----------------------------------------------------------------------------
*   Set strings
*----------------------------------------------------------------------------*/

/* clear the string, keep allocated space */
extern void str_clear(Str *str);

/* sync length in case string was modified in place */
extern void str_sync_len(Str *str);

/* set / append string */
extern void str_set(Str *str, char *source);
extern void str_append(Str *str, char *source);

/* set / append substring */
extern void str_set_n(Str *str, char *source, int count);
extern void str_append_n(Str *str, char *source, int count);

/* set / append bytes */
extern void str_set_bytes(Str *str, char *source, int size);
extern void str_append_bytes(Str *str, char *source, int size);

/* set / append char */
extern void str_set_char(Str *str, char ch);
extern void str_append_char(Str *str, char ch);

/* set / append with printf-like parameters */
extern void str_sprintf(Str *str, char *format, ...);
extern void str_append_sprintf(Str *str, char *format, ...);

/* set / append with va_list argument */
extern void str_vsprintf(Str *str, char *format, va_list argptr);
extern void str_append_vsprintf(Str *str, char *format, va_list argptr);

/*-----------------------------------------------------------------------------
*   Modify strings
*----------------------------------------------------------------------------*/

/* tolower, toupper, chomp, strip, compress_escapes */
extern void str_toupper(Str *str);
extern void str_tolower(Str *str);
extern void str_chomp(Str *str);
extern void str_strip(Str *str);
extern void str_compress_escapes(Str *str);

/* get one line from input, convert end-of-line sequences,
*  return string including one LF character
*  return FALSE on end of input */
extern Bool str_getline(Str *str, FILE *fp);
