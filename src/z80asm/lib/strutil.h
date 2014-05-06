/*
Utilities working on strings.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strutil.h,v 1.16 2014-05-06 22:17:38 pauloscustodio Exp $
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
extern UINT str_compress_escapes( char *string );

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
	UINT	 size;		/* allocated size */
	UINT	 len;		/* sring length (excluding zero terminator) */
	BOOL	 alloc_str;	/* TRUE if str is in the heap and can grow
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
extern void Str_reserve( Str *self, UINT num_chars );

/* delete extra unused space */
extern void Str_unreserve( Str *self );

/* set / append string */
extern void Str_set( Str *self, char *source );
extern void Str_append( Str *self, char *source );

/* set / append substring */
extern void Str_set_n( Str *self, char *source, UINT count );
extern void Str_append_n( Str *self, char *source, UINT count );

/* set / append bytes */
extern void Str_set_bytes( Str *self, char *source, UINT size );
extern void Str_append_bytes( Str *self, char *source, UINT size );

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
extern BOOL Str_vsprintf( Str *self, char *format, va_list argptr );
extern BOOL Str_append_vsprintf( Str *self, char *format, va_list argptr );

/* chomp, strip, compress_escapes */
extern void Str_chomp( Str *self );
extern void Str_strip( Str *self );
extern void Str_compress_escapes( Str *self );

/* get N characters from input, return FALSE on EOF */
extern BOOL Str_getchars( Str *self, FILE *fp, UINT num_chars );

/* get one line from input, convert end-of-line sequences,
   return string including one LF character
   return FALSE on end of input */
extern BOOL Str_getline( Str *self, FILE *fp );


/*
* $Log: strutil.h,v $
* Revision 1.16  2014-05-06 22:17:38  pauloscustodio
* Made types BYTE, UINT and ULONG all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.15  2014/05/02 21:34:58  pauloscustodio
* byte_t, uint_t and ulong_t renamed to BYTE, UINT and ULONG
*
* Revision 1.14  2014/04/19 14:57:37  pauloscustodio
* BUG_0046: Expressions stored in object file with wrong values in MacOS
* Symthom: ZERO+2*[1+2*(1+140709214577656)] stored instead of ZERO+2*[1+2*(1+2)]
* Problem caused by non-portable way of repeating a call to vsnprintf without
* calling va_start in between. The repeated call is necessary when the
* dynamically allocated string needs to grow to fit the value to be stored.
*
* Revision 1.13  2014/03/29 22:04:11  pauloscustodio
* Add str_compress_escapes() to compress C-like escape sequences.
* Accepts \a, \b, \e, \f, \n, \r, \t, \v, \xhh, \{any} \ooo, allows \0 in the string.
*
* Revision 1.12  2014/03/19 23:04:57  pauloscustodio
* Add Str_set_alias() to define an alias char* that always points to self->str
* Add Str_set_n() and Str_append_n() to copy substrings.
*
* Revision 1.11  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.10  2014/02/25 22:39:35  pauloscustodio
* ws
*
* Revision 1.9  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UINT and ULONG, use UINT instead of size_t.
*
* Revision 1.8  2014/01/21 21:31:52  pauloscustodio
* ws
*
* Revision 1.7  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.6  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.5  2014/01/02 02:46:42  pauloscustodio
* new strip() function to eliminate start and end blanks from string
*
* Revision 1.4  2014/01/01 21:36:38  pauloscustodio
* No dependency on glib
*
* Revision 1.3  2013/12/30 02:05:34  pauloscustodio
* Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
* handles both dynamically allocated strings and fixed-size strings.
* Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
* g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
*
* Revision 1.2  2013/12/26 23:42:27  pauloscustodio
* Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
*
* Revision 1.1  2013/12/25 14:39:51  pauloscustodio
* Move strutil.c to the z80asm/lib directory
*
* Revision 1.17  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.16  2013/09/24 00:05:36  pauloscustodio
*
* Revision 1.15  2013/09/23 23:14:10  pauloscustodio
* Renamed SzList to StringList, simplified interface by assuming that
* list lives in memory util program ends; it is used for directory searches
* only. Moved interface to strutil.c, removed strlist.c.
*
* Revision 1.14  2013/04/29 22:24:33  pauloscustodio
* Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
*
* Revision 1.13  2013/02/19 22:52:40  pauloscustodio
* BUG_0030 : List bytes patching overwrites header
* BUG_0031 : List file garbled with input lines with 255 chars
* New listfile.c with all the listing related code
*
* Revision 1.12  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.11  2012/11/03 17:39:36  pauloscustodio
* astyle, comments
*
* Revision 1.10  2012/06/14 15:01:27  pauloscustodio
* Split safe strings from strutil.c to safestr.c
*
* Revision 1.9  2012/06/07 11:49:59  pauloscustodio
* stricompare() instead of Flncmp()
*
* Revision 1.8  2012/05/26 17:46:00  pauloscustodio
* Put back strtoupper, strupr does not exist in all systems, was causing nightly build to fail
*
* Revision 1.7  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.6  2012/05/24 17:00:43  pauloscustodio
* astyle
*
* Revision 1.5  2012/05/24 15:07:03  pauloscustodio
* Rename safestr_t to sstr_t, keep length to speed-up appending chars
*
* Revision 1.4  2012/05/22 20:35:26  pauloscustodio
* astyle
*
* Revision 1.3  2012/05/22 20:26:17  pauloscustodio
* Safe strings
* New type sstr_t to hold strings with size to prevent buffer overruns.
* Remove strtoupper, use POSIX strupr instead
*
* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.1  2011/10/14 13:48:05  pauloscustodio
* String utilities
*
*/
