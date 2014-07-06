/*
Utilities working on strings.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/strutil.c,v 1.19 2014-07-06 23:11:25 pauloscustodio Exp $
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

    p = string + strlen( string ) - 1;	/* point at last char */

    while ( p >= string && isspace( *p ) )
    {
        *p = '\0';
        p--;
    }

    return string;
}

char *strip( char *string )
{
    char *p;

    /* remove start spaces */
    p = string;

    while ( *p != '\0' && isspace( *p ) )
        p++;

    memmove( string, p, strlen( p ) + 1 );	/* copy also '\0' */

    /* remove end spaces */
    return chomp( string );
}

static int char_digit(char c)
{
	if (isdigit(c)) return c - '0';
	if (isxdigit(c)) return 10 + toupper(c) - 'A';
	return -1;
}

/* convert C-escape sequences - modify in place, return final length 
   to allow strings with '\0' characters 
   Accepts \a, \b, \e, \f, \n, \r, \t, \v, \xhh, \{any} \ooo
   code borrowed from GLib */
size_t str_compress_escapes( char *string )
{
	char *p, *q, *num;
	int base = 0, max_digits, digit;

	for ( p = q = string; *p; p++ )
	{
		if (*p == '\\')
		{
			p++;
			base = 0;							/* decision octal/hex */
			switch (*p)
			{
            case '\0':	p--; break;				/* trailing backslash - ignore */
			case 'a':	*q++ = '\a'; break;
			case 'b':	*q++ = '\b'; break;
			case 'e':	*q++ = '\x1B'; break;
			case 'f':	*q++ = '\f'; break;
			case 'n':	*q++ = '\n'; break;
			case 'r':	*q++ = '\r'; break;
			case 't':	*q++ = '\t'; break;
			case 'v':	*q++ = '\v'; break;
			case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7':
				num = p;				/* start of number */
				base = 8;
				max_digits = 3;
				/* fall through */
			case 'x':
				if ( base == 0 )		/* not octal */
				{
					num = ++p;
					base = 16;
					max_digits = 2;
				}
				/* convert octal or hex number */
				*q = 0;
				while ( p < num + max_digits && 
					    (digit = char_digit(*p)) >= 0 &&
						digit < base )
				{
					*q = *q * base + digit;
					p++;
				}
				p--; 
				q++;
				break;
			default:	*q++ = *p;		/* any other char */
			}
		}
		else
		{
			*q++ = *p;
		}
	}
	*q = '\0';

	return q - string;
}

/*-----------------------------------------------------------------------------
*   String class
*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
*   Constants
*----------------------------------------------------------------------------*/
#define SIZE_MASK       0x0F        /* size will increment in blocks of 16 */

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
	self->palias = NULL;		/* copy cannot point to same alias */
}

void Str_fini( Str *self )
{
    if ( self->alloc_str )
        xfree( self->str );
}

/*-----------------------------------------------------------------------------
*   handle alias alias char* that always points to self->str
*----------------------------------------------------------------------------*/
static void Str_update_alias( Str *self )
{
	if ( self->palias != NULL )
		*(self->palias) = self->str;
}

void Str_set_alias( Str *self, char **palias )
{
	self->palias = palias;
	Str_update_alias( self );
}

/*-----------------------------------------------------------------------------
*   Modify Str
*----------------------------------------------------------------------------*/
void Str_clear( Str *self )
{
	self->str[0] = '\0';
	self->len    = 0;
	Str_update_alias( self );
}

void Str_sync_len( Str *self )
{
	self->len = strlen( self->str );
	Str_update_alias( self );
}

void Str_chomp( Str *self )
{
	chomp( self->str );
	Str_sync_len( self );
}

void Str_strip( Str *self )
{
	strip( self->str );
	Str_sync_len( self );
}

void Str_compress_escapes( Str *self )
{
	/* no Str_sync_len() as string may have '\0' */
	self->len = str_compress_escapes( self->str );
}

/*-----------------------------------------------------------------------------
*   expand if needed to store at least more num_chars plus a zero byte
*   increment size in blocks of SIZE_MASK
*----------------------------------------------------------------------------*/
void Str_reserve( Str *self, size_t num_chars )
{
    size_t need_size, new_size;

    if ( self->alloc_str )
	{
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
			/* round up in blocks of SIZE_MASK */
			new_size = need_size & ~SIZE_MASK;

			if ( new_size < need_size )
			{
				new_size += SIZE_MASK + 1;
			}

			self->str = ( char * ) xrealloc( self->str, new_size );
			self->size = new_size;
		}
	}
	
	Str_update_alias( self );
}

/*-----------------------------------------------------------------------------
*   delete extra unused space
*----------------------------------------------------------------------------*/
void Str_unreserve( Str *self )
{
    size_t need_size;

    if ( self->alloc_str )
	{
		need_size = self->len + 1;
		self->str = ( char * ) xrealloc( self->str, need_size );
		self->size = need_size;
	}

	Str_update_alias( self );
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
    Str_append_bytes( self, source, strlen( source ) );
}

/*-----------------------------------------------------------------------------
*   set / append substring, add always a zero byte after
*----------------------------------------------------------------------------*/
void Str_set_n( Str *self, char *source, size_t count )
{
    Str_clear( self );
    Str_append_n( self, source, count );
}

void Str_append_n( Str *self, char *source, size_t count )
{
    Str_append_bytes( self, source, MIN( count, strlen(source) ) );
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
Bool Str_vsprintf( Str *self, char *format, va_list argptr )
{
    Str_clear( self );
    return Str_append_vsprintf( self, format, argptr );
}

Bool Str_append_vsprintf( Str *self, char *format, va_list argptr )
{
    int     free_space;      /* may be negative */
    int     need_space;

    /* BUG_0022 : Linux vsnprintf always terminates string;
    			  Win32 only if there is enough space */
	/* BUG_0046: cannot retry, return FALSE if user needs to retry */
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
            /* increase the size by SIZE_MASK and return FALSE */
            /* +1 -> overflow -> cause new block to be requested */
            Str_reserve( self, self->size - self->len + 1 );
			return FALSE;
        }
        else
        {
            self->str[ self->size - 1 ] = '\0';	/* string may not be terminated */
            Str_sync_len( self );
            return TRUE;					/* cannot expand, return truncated */
        }
    }
    else                                    /* string was terminated */
    {
        self->len += need_space;
        return TRUE;						/* output OK */
    }
}

void Str_sprintf( Str *self, char *format, ... )
{
    va_list argptr;
	Bool ok;

	do								/* BUG_0046 */
	{
		va_start( argptr, format );
		ok = Str_vsprintf( self, format, argptr );
		va_end( argptr );
	} while ( ! ok );
}

void Str_append_sprintf( Str *self, char *format, ... )
{
    va_list argptr;
	Bool ok;

	do								/* BUG_0046 */
	{
		va_start( argptr, format );
		ok = Str_append_vsprintf( self, format, argptr );
		va_end( argptr );
	} while ( ! ok );
}

/*-----------------------------------------------------------------------------
*   get N characters from input, return FALSE on EOF
*----------------------------------------------------------------------------*/
Bool Str_getchars( Str *self, FILE *fp, size_t num_chars )
{
    int c = EOF;

    Str_clear( self );

    while ( num_chars-- > 0 && ( c = getc( fp ) ) != EOF )
        Str_append_char( self, c );

    return c == EOF ? FALSE : TRUE;
}

/*-----------------------------------------------------------------------------
*   get one line from input, convert end-of-line sequences,
*   return string including one LF character
*   return FALSE on end of input
*----------------------------------------------------------------------------*/
Bool Str_getline( Str *self, FILE *fp )
{
    int c1, c2;

    Str_clear( self );

    while ( ( c1 = getc( fp ) ) != EOF && c1 != '\n' && c1 != '\r' )
        Str_append_char( self, c1 );

    if ( c1 == EOF )
    {
        if ( self->len > 0 )					/* read some chars */
            Str_append_char( self, '\n' );		/* missing newline at end of line */
    }
    else
    {
        Str_append_char( self, '\n' );			/* end of line */

        if ( ( c2 = getc( fp ) ) != EOF &&
                !( ( c1 == '\n' && c2 == '\r' ) ||
                   ( c1 == '\r' && c2 == '\n' ) ) )
        {
            ungetc( c2, fp );					/* push back to input */
        }
    }

    return self->len > 0 ? TRUE : FALSE;
}
