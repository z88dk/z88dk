/*
Utilities working on strings.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strutil.c,v 1.3 2013-12-30 02:05:34 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "strpool.h"
#include "strutil.h"
#include <ctype.h>
#include <string.h>

/*-----------------------------------------------------------------------------
*   Utilities
*----------------------------------------------------------------------------*/

char *strtoupper( char *string )
{
    char *p;

    for ( p = string; *p; p++ )
        *p = toupper( *p );

    return string;
}

char *strtolower( char *string )
{
    char *p;

    for ( p = string; *p; p++ )
        *p = tolower( *p );

    return string;
}

int stricompare( char *s1, char *s2 )
{
    char c1, c2;

    while ( 1 )
    {
        c1 = *s1++;
        c1 = tolower( c1 );
        c2 = *s2++;
        c2 = tolower( c2 );

        if ( c1 == 0 && c2 == 0 )
        {
            return 0;           /* equal */
        }
        else if ( c1 < c2 )
        {
            return -1;          /* s1 comes before */
        }
        else if ( c1 > c2 )
        {
            return 1;           /* s2 comes before */
        }
        else
        {
            ;                   /* check next */
        }
    }
}

char *chomp( char *string )
{
	char *p;

	p = string + strlen(string) - 1;	/* point at last char */
	while (p >= string && (*p == '\n' || *p == '\r' || *p == '\f' || *p == '\t' || *p == ' '))
	{
		*p = '\0';
		p--;
	}
	return string;
}

/*-----------------------------------------------------------------------------
*   String class
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Constants
*----------------------------------------------------------------------------*/
#define SIZE_MASK       0xFF        /* size will increment in blocks of 256 */

/*-----------------------------------------------------------------------------
*   Class inplementation
*----------------------------------------------------------------------------*/
DEF_CLASS( Str );

void Str_init( Str *self )
{
	self->alloc_str = TRUE;
    Str_reserve( self, 0 );
    Str_clear( self );
}

void Str_copy( Str *self, Str *other )
{
    char *data_copy = xnew_n( char, self->size );
    memcpy( data_copy, self->str, self->size );
	self->alloc_str = TRUE;
    self->str = data_copy;
}

void Str_fini( Str *self )
{
	if ( self->alloc_str )
		xfree( self->str );
}

/*-----------------------------------------------------------------------------
*   expand if needed to store at least more num_chars plus a zero byte
*   increment size in blocks of SIZE_MASK (256)
*----------------------------------------------------------------------------*/
void Str_reserve( Str *self, size_t num_chars )
{
    size_t need_size, new_size;

	if ( ! self->alloc_str )		/* exit if fixed-buffer */
		return;

    if ( self->size == 0 )          /* empty data */
    {
        need_size = num_chars + 1;
    }
    else                            /* append to existing string */
    {
        need_size = self->len + num_chars + 1;
    }

    if ( self->size < need_size )
    {
        /* round up in blocks of 256 */
        new_size = need_size & ~SIZE_MASK;

        if ( new_size < need_size )
        {
            new_size += SIZE_MASK + 1;
        }

        self->str = ( char * ) xrealloc( self->str, new_size );
        self->size = new_size;
    }
}

/*-----------------------------------------------------------------------------
*   delete extra unused space
*----------------------------------------------------------------------------*/
void Str_unreserve( Str *self )
{
    size_t need_size;

	if ( ! self->alloc_str )		/* exit if fixed-buffer */
		return;

	need_size = self->len + 1;
    self->str = ( char * ) xrealloc( self->str, need_size );
    self->size = need_size;
}

/*-----------------------------------------------------------------------------
*   set / append from memory buffer, add always a zero byte after
*----------------------------------------------------------------------------*/
void Str_set_bytes( Str *self, char *source, size_t size )
{
    Str_clear( self );
    Str_append_bytes( self, source, size );
}

void Str_append_bytes( Str *self, char *source, size_t size )
{
    size_t num_copy;
	
	/* expand string if needed and possible */	
    Str_reserve( self, size );
	
	/* determine number of bytes to copy, include space for extra null byte */
	if ( self->len + size + 1 > self->size )
		num_copy = self->size - self->len - 1;		/* truncate */
	else
		num_copy = size;							/* full copy */

	/* copy buffer and add null terminator */
    memcpy( self->str + self->len, source, num_copy );
	self->len += num_copy;
	self->str[ self->len ] = '\0';					/* add zero terminator */
}

/*-----------------------------------------------------------------------------
*   set / append from string, add always a zero byte after
*----------------------------------------------------------------------------*/
void Str_set( Str *self, char *source )
{
    Str_clear( self );
	Str_append( self, source );
}

void Str_append( Str *self, char *source )
{
	Str_append_bytes( self, source, strlen(source) );
}

/*-----------------------------------------------------------------------------
*   set / append from char, add always a zero byte after
*----------------------------------------------------------------------------*/
void Str_set_char( Str *self, char ch )
{
    Str_clear( self );
	Str_append_char( self, ch );
}

void Str_append_char( Str *self, char ch )
{
	/* expand string if needed and possible */	
    Str_reserve( self, 1 );

	/* add bytes if enough space */
	if ( self->len + 2 <= self->size )
	{
		self->str[ self->len++ ] = ch;
		self->str[ self->len   ] = '\0';
	}
}

/*-----------------------------------------------------------------------------
*   set / append with printf-like parameters
*----------------------------------------------------------------------------*/
void Str_vsprintf( Str *self, char *format, va_list argptr )
{
    Str_clear( self );
	Str_append_vsprintf( self, format, argptr );
}

void Str_append_vsprintf( Str *self, char *format, va_list argptr )
{
    int     free_space;      /* may be negative */
    int     need_space;

    /* BUG_0022 : Linux vsnprintf always terminates string; 
				  Win32 only if there is enough space */
	while (1) 
	{
		free_space = self->size - self->len;
		
		if ( free_space > 0 ) 		
			need_space = vsnprintf( self->str + self->len, (size_t) free_space,
									format, argptr );
	
        if ( free_space <= 0 ||					/* no free space */
			 need_space >= free_space || 		/* or not enough space */
		     need_space < 0 )    				/* or error */
        {
			if ( self->alloc_str )
			{
				/* increase the size by 256 and try again */
				/* +1 -> overflow -> cause new block to be requested */
				Str_reserve( self, self->size - self->len + 1 );
			}
			else
			{
				self->str[ self->size - 1 ] = '\0';	/* string may not be terminated */
				Str_sync_len( self );
				break;							/* cannot expand, return truncated */
			}
        }
        else                                    /* string was terminated */
        {
            self->len += need_space;
			break;								/* output OK */
        }
	}
}

void Str_sprintf( Str *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    Str_vsprintf( self, format, argptr );
}

void Str_append_sprintf( Str *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    Str_append_vsprintf( self, format, argptr );
}

/*-----------------------------------------------------------------------------
*   get N characters from input, return FALSE on EOF
*----------------------------------------------------------------------------*/
BOOL Str_getchars( Str *self, FILE *fp, size_t num_chars )
{
	int c = EOF;
	
	Str_clear( self );
	while ( num_chars-- > 0 && (c = getc( fp )) != EOF )
		Str_append_char( self, c );
		
	return c == EOF ? FALSE : TRUE;
}

/*-----------------------------------------------------------------------------
*   get one line from input, convert end-of-line sequences, 
*   return string including one LF character
*   return FALSE on end of input
*----------------------------------------------------------------------------*/
BOOL Str_getline( Str *self, FILE *fp )
{
	int c1, c2;
	
	Str_clear( self );
	while ( (c1 = getc( fp )) != EOF && c1 != '\n' && c1 != '\r' )
		Str_append_char( self, c1 );
	
	if ( c1 == EOF )
	{
		if ( self->len > 0 )					/* read some chars */
			Str_append_char( self, '\n' );		/* missing newline at end of line */
	}
	else 						
	{
		Str_append_char( self, '\n' );			/* end of line */
		
		if ( (c2 = getc( fp )) != EOF &&
			 ! ( ( c1 == '\n' && c2 == '\r' ) ||
				 ( c1 == '\r' && c2 == '\n' ) ) )
		{
			ungetc( c2, fp );					/* push back to input */
		}
	}
	
	return self->len > 0 ? TRUE : FALSE;
}


/* 
* $Log: strutil.c,v $
* Revision 1.3  2013-12-30 02:05:34  pauloscustodio
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
* Revision 1.19  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.18  2013/09/24 00:08:45  pauloscustodio
* braces
*
* Revision 1.17  2013/09/24 00:05:36  pauloscustodio
*
* Revision 1.16  2013/09/23 23:14:10  pauloscustodio
* Renamed SzList to StringList, simplified interface by assuming that
* list lives in memory util program ends; it is used for directory searches
* only. Moved interface to strutil.c, removed strlist.c.
*
* Revision 1.15  2013/04/29 22:24:33  pauloscustodio
* Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
*
* Revision 1.14  2013/03/30 00:02:22  pauloscustodio
* include xmalloc.h before any other include
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
* Revision 1.8  2012/06/06 22:42:57  pauloscustodio
* BUG_0022 : Different behaviour in string truncation in strutil in Linux and Win32
*
* Revision 1.7  2012/05/26 17:46:00  pauloscustodio
* Put back strtoupper, strupr does not exist in all systems, was causing nightly build to fail
*
* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.5  2012/05/24 17:00:43  pauloscustodio
* astyle
*
* Revision 1.4  2012/05/24 15:07:03  pauloscustodio
* Rename safestr_t to sstr_t, keep length to speed-up appending chars
*
* Revision 1.3  2012/05/22 20:26:17  pauloscustodio
* Safe strings
* New type sstr_t to hold strings with size to prevent buffer overruns.
* Remove strtoupper, use POSIX strupr instead
*
* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
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
