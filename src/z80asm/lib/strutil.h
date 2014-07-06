/*
Utilities working on strings.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strutil.h,v 1.20 2014-07-06 23:11:25 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"				/* before any other include */
#include "class.h"
#include "types.h"
#include <stdarg.h>
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*   Utilities
*----------------------------------------------------------------------------*/

/* convert string to upper/lower case - modify in place,
   return address of string */
extern char *strtoupper( char *string );
extern char *strtolower( char *string );

/* case insensitive compare */
extern int stricompare( char *s1, char *s2 );

/* remove end newline and whitespace - modify in place, return address of string */
extern char *chomp( char *string );

/* remove begin and end whitespace - modify in place, return address of string */
extern char *strip( char *string );

/* convert C-escape sequences - modify in place, return final length 
   to allow strings with '\0' characters 
   Accepts \b, \f, \n, \r, \t, \v, \xhh, \? \ooo */
extern size_t str_compress_escapes( char *string );

/*-----------------------------------------------------------------------------
*   String class - dual use
*
*	- dynamically allocated strings that grow as needed
*		Str *s1 = OBJ_NEW(String);
*		OBJ_DELETE(s1);
*
*	- fixed max-size strings for usage as auto variables
*		char buffer[MAXLINE] = "";
*		Str _s2 = INIT_STR( buffer );
*		Str *s2 = &_s2;
*		// or
*		DEFINE_STR( s3, MAXLINE );
*
*	s2.str				// data bytes
*	s2.len				// length excluding zero terminator
*	Str_sync_len(&s2)	// syncronize s2.len after s2.str is manipulated
*----------------------------------------------------------------------------*/
CLASS( Str )
	char	*str;		/* string - may contain zero bytes */
	char   **palias;	/* points to a char* alias variable that is always kept pointing
						   to self->str; useful to export a char* that always points
						   at the buffer */
	size_t	 size;		/* allocated size */
	size_t	 len;		/* sring length (excluding zero terminator) */
	Bool	 alloc_str;	/* TRUE if str is in the heap and can grow
						   FALSE if str is in user supplied buffer and cannot grow */
END_CLASS;

/* define Str with user supplied buffer */
#define INIT_STR( buffer )	\
			{ CLASS_INITIALIZER, buffer, NULL, sizeof(buffer), 0, FALSE }

#define DEFINE_STR( str, maxsize )	\
			char	str##_data [ maxsize ] = "";	\
			Str		_##str = INIT_STR( str##_data );	\
			Str		* str = & _##str

/* clear the string, keep allocated space */
extern void Str_clear( Str *self );

/* sync length in case string was modified in place */
extern void Str_sync_len( Str *self );

/* set alias char* that always points to self->str */
extern void Str_set_alias( Str *self, char **palias );

/* expand if needed to store at least more num_chars plus a zero byte */
extern void Str_reserve( Str *self, size_t num_chars );

/* delete extra unused space */
extern void Str_unreserve( Str *self );

/* set / append string */
extern void Str_set( Str *self, char *source );
extern void Str_append( Str *self, char *source );

/* set / append substring */
extern void Str_set_n( Str *self, char *source, size_t count );
extern void Str_append_n( Str *self, char *source, size_t count );

/* set / append bytes */
extern void Str_set_bytes( Str *self, char *source, size_t size );
extern void Str_append_bytes( Str *self, char *source, size_t size );

/* set / append char */
extern void Str_set_char( Str *self, char ch );
extern void Str_append_char( Str *self, char ch );

/* set / append with printf-like parameters */
extern void Str_sprintf( Str *self, char *format, ... );
extern void Str_append_sprintf( Str *self, char *format, ... );

/* set / append with va_list argument
   vsnprintf() in some platforms cannot be called twice with same va_list (BUG_0046), 
   need to call va_start/va_end between calls; therefore this API does not retry.
   If the string fits, the funtion returns TRUE.
   If the string does not fit and can be expanded, it is expanded and the function
   returns FALSE; the user has to call va_end, va_start and retry.
   If the string does not fit and cannot be expanded, it is truncated and the function
   returns TRUE. */ 
extern Bool Str_vsprintf( Str *self, char *format, va_list argptr );
extern Bool Str_append_vsprintf( Str *self, char *format, va_list argptr );

/* chomp, strip, compress_escapes */
extern void Str_chomp( Str *self );
extern void Str_strip( Str *self );
extern void Str_compress_escapes( Str *self );

/* get N characters from input, return FALSE on EOF */
extern Bool Str_getchars( Str *self, FILE *fp, size_t num_chars );

/* get one line from input, convert end-of-line sequences,
   return string including one LF character
   return FALSE on end of input */
extern Bool Str_getline( Str *self, FILE *fp );
