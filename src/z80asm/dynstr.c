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

Copyright (C) Paulo Custodio, 2011-2013

Str : Dynamic-length strings based on http://uthash.sourceforge.net/utstring
Using class.h for automatic garbage collection.
Strings may contain zero byte, length is defined by separate field.
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/dynstr.c,v 1.11 2013-09-12 00:10:02 pauloscustodio Exp $ */
/* $Log: dynstr.c,v $
/* Revision 1.11  2013-09-12 00:10:02  pauloscustodio
/* Create g_free0() macro that NULLs the pointer after free, required
/* by z80asm to find out if a pointer was already freed.
/*
/* Revision 1.10  2013/09/08 08:29:21  pauloscustodio
/* Replaced xmalloc et al with g_malloc0 et al.
/*
/* Revision 1.9  2013/05/01 21:10:49  pauloscustodio
/* Add getline to Str, converting EOL sequences to LF.
/*
/* Revision 1.8  2013/04/29 22:24:33  pauloscustodio
/* Add utility functions to convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
/*
/* Revision 1.7  2013/03/30 00:02:22  pauloscustodio
/* include memalloc.h before any other include
/*
/* Revision 1.6  2013/02/28 00:32:35  pauloscustodio
/* New interface to Str to copy characters to string
/*
/* Revision 1.5  2013/02/22 17:21:29  pauloscustodio
/* Added chomp()
/*
/* Revision 1.4  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.3  2013/01/19 00:04:53  pauloscustodio
/* Implement StrHash_clone, required change in API of class.h and all classes that used it.
/*
/* Revision 1.2  2012/11/03 17:39:36  pauloscustodio
/* astyle, comments
/*
/* Revision 1.1  2012/06/14 15:03:45  pauloscustodio
/* CH_0014 : New Dynamic Strings that grow automatically on creation / concatenation
/*
/*
/* */

#include "memalloc.h"   /* before any other include */
#include <string.h>
#include <ctype.h>
#include "dynstr.h"
#include "strutil.h"

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
    Str_reserve( self, 0 );
    Str_clear( self );
}

void Str_copy( Str *self, Str *other )
{
    char *data_copy = g_malloc0( self->size );
    memcpy( data_copy, self->data, self->size );
    self->data = data_copy;
}

void Str_fini( Str *self )
{
    g_free0( self->data );
}

/*-----------------------------------------------------------------------------
*   expand if needed to store at least more num_chars plus a zero byte
*   increment size in blocks of SIZE_MASK (256)
*----------------------------------------------------------------------------*/
void Str_reserve( Str *self, size_t num_chars )
{
    size_t need_size, new_size;

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

        self->data = ( char * ) g_realloc( self->data, new_size );
        self->size = new_size;
    }
}

/*-----------------------------------------------------------------------------
*   delete extra unused space
*----------------------------------------------------------------------------*/
void Str_unreserve( Str *self )
{
    size_t need_size = self->len + 1;

    self->data = ( char * ) g_realloc( self->data, need_size );
    self->size = need_size;
}

/*-----------------------------------------------------------------------------
*   set / cat from memory buffer, add always a zero byte after
*----------------------------------------------------------------------------*/
void Str_bset( Str *self, char *source, size_t size )
{
    Str_clear( self );
    Str_bcat( self, source, size );
}

void Str_bcat( Str *self, char *source, size_t size )
{
    Str_reserve( self, size );

    memcpy( self->data + self->len, source, size );
    self->data[ self->len + size ] = 0;         /* add zero terminator */

    self->len += size;
}

/*-----------------------------------------------------------------------------
*   set / cat from char
*----------------------------------------------------------------------------*/
void Str_chset( Str *self, char ch )
{
    Str_clear( self );
    Str_chcat( self, ch );
}

void Str_chcat( Str *self, char ch )
{
	char buff[2];

	/* build sz string */
	buff[0] = ch;
	buff[1] = 0;

	/* szcat */
	Str_szcat( self, buff );
}


/*-----------------------------------------------------------------------------
*   sprintf-like set / cat
*----------------------------------------------------------------------------*/
void Str_vfset( Str *self, char *format, va_list argptr )
{
    Str_clear( self );
    Str_vfcat( self, format, argptr );
}

void Str_vfcat( Str *self, char *format, va_list argptr )
{
    int    count;
    size_t free;

    /* print to string and expand if needed */
    while ( 1 )
    {
        free = self->size - self->len - 1;

        /* vsnprintf needs free > 0 */
        if ( free > 0 )
        {
            count = vsnprintf( self->data + self->len, free, format, argptr );

            if ( count >= 0 )
            {
                break;    /* done */
            }
        }

        /* increase the size by 256 and try again */
        /* +1 -> overflow -> cause new block to be requested */
        Str_reserve( self, self->size - self->len + 1 );
    }

    self->len += count;
}

void Str_fset( Str *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    Str_vfset( self, format, argptr );
}

void Str_fcat( Str *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    Str_vfcat( self, format, argptr );
}

/*-----------------------------------------------------------------------------
*   remove end newlines and whitespace
*----------------------------------------------------------------------------*/
void Str_chomp( Str *self )
{
	chomp( Str_data(self) );
	Str_sync_len(self);
}

/*-----------------------------------------------------------------------------
*   convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
*----------------------------------------------------------------------------*/
void Str_normalize_eol( Str *self )
{
	normalize_eol( Str_data(self) );
	Str_sync_len(self);
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
		Str_chcat( self, c1 );
	
	if ( c1 == EOF )
	{
		if ( Str_len( self ) > 0 )			/* read some chars */
			Str_chcat( self, '\n' );		/* missing newline at end of line */
	}
	else 						
	{
		Str_chcat( self, '\n' );			/* end of line */
		
		if ( (c2 = getc( fp )) != EOF &&
			 ! ( c1 == '\n' && c2 == '\r' ||
				 c1 == '\r' && c2 == '\n' ) )
		{
			ungetc( c2, fp );				/* push back to input */
		}
	}
	
	return Str_len( self ) > 0 ? TRUE : FALSE;
}

 
