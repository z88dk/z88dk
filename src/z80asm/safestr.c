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

Safe strings : char array with the size
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/safestr.c,v 1.9 2013-09-01 12:00:07 pauloscustodio Exp $ */
/* $Log: safestr.c,v $
/* Revision 1.9  2013-09-01 12:00:07  pauloscustodio
/* Cleanup compilation warnings
/*
/* Revision 1.8  2013/05/07 22:10:56  pauloscustodio
/* sstr_getchars(): get N characters from input, return FALSE on EOF
/*
/* Revision 1.7  2013/05/02 21:21:50  pauloscustodio
/* warnings
/*
/* Revision 1.6  2013/05/01 22:23:39  pauloscustodio
/* Added chomp and normalize_eol
/*
/* Revision 1.5  2013/05/01 21:37:50  pauloscustodio
/* Added chset, chcat and getline
/*
/* Revision 1.4  2013/03/30 00:02:22  pauloscustodio
/* include memalloc.h before any other include
/*
/* Revision 1.3  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.2  2012/11/03 17:39:36  pauloscustodio
/* astyle, comments
/*
/* Revision 1.1  2012/06/14 15:01:27  pauloscustodio
/* Split safe strings from strutil.c to safestr.c
/*
/*
/* */

#include "memalloc.h"   /* before any other include */

#include "safestr.h"
#include "strutil.h"
#include "types.h"
#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

/*-----------------------------------------------------------------------------
*   sstr_set, sstr_cat : return address of data
*----------------------------------------------------------------------------*/
char *sstr_set( sstr_t *self, char *source )
{
    sstr_clear( self );
    return sstr_cat( self, source );
}

char *sstr_cat( sstr_t *self, char *source )
{
    size_t  mylen = sstr_len( self );
    size_t  sourcelen = strlen( source );
    size_t  ncopy;

    if ( mylen + sourcelen + 1 > self->size )
    {
        ncopy = self->size - mylen - 1;     /* truncate */
    }
    else
    {
        ncopy = sourcelen;                  /* full copy */
    }

    /* copy and null-terminate */
    memcpy( sstr_data( self ) + mylen, source, ncopy );
    sstr_len( self ) = mylen + ncopy;
    sstr_data( self )[ sstr_len( self ) ] = 0;

    return sstr_data( self );
}

/*-----------------------------------------------------------------------------
*   sstr_set, sstr_cat : return address of data
*----------------------------------------------------------------------------*/
char *sstr_chset( sstr_t *self, char ch )
{
    sstr_clear( self );
    return sstr_chcat( self, ch );
}

char *sstr_chcat( sstr_t *self, char ch )
{
	char buff[2];

	/* build sz string */
	buff[0] = ch;
	buff[1] = 0;

	/* cat */
	return sstr_cat( self, buff );
}

/*-----------------------------------------------------------------------------
*   sprintf-like set / cat
*----------------------------------------------------------------------------*/
char *sstr_vfset( sstr_t *self, char *format, va_list argptr )
{
    sstr_clear( self );
    return sstr_vfcat( self, format, argptr );
}

char *sstr_vfcat( sstr_t *self, char *format, va_list argptr )
{
    size_t  mylen = sstr_len( self );
    int     ncopy;      /* may be negative */
    int     copied;

    /* BUG_0022 : Linux vsnprintf always terminates string; Win32 only if there is enough space */
    ncopy = self->size - mylen;         /* full space including null terminator */

    if ( ncopy > 0 )
    {
        /* returns number of chars written, or -1 if output truncated */
        copied = vsnprintf( sstr_data( self ) + mylen, ( size_t )ncopy, format, argptr );

        if ( copied >= ncopy || copied < 0 )    /* string may not be terminated */
        {
            sstr_data( self )[self->size - 1] = 0;
            sstr_sync_len( self );
        }
        else                                    /* string was terminated */
        {
            sstr_len( self ) += copied;
        }
    }

    return sstr_data( self );
}

char *sstr_fset( sstr_t *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    return sstr_vfset( self, format, argptr );
}

char *sstr_fcat( sstr_t *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    return sstr_vfcat( self, format, argptr );
}

/*-----------------------------------------------------------------------------
*   remove end newlines and whitespace
*----------------------------------------------------------------------------*/
void sstr_chomp( sstr_t *self )
{
	chomp( sstr_data(self) );
	sstr_sync_len(self);
}

/*-----------------------------------------------------------------------------
*   convert end-of-line sequences CR, CRLF, LFCR, LF all to LF
*----------------------------------------------------------------------------*/
void sstr_normalize_eol( sstr_t *self )
{
	normalize_eol( sstr_data(self) );
	sstr_sync_len(self);
}

/*-----------------------------------------------------------------------------
*   get N characters from input, return FALSE on EOF
*----------------------------------------------------------------------------*/
BOOL sstr_getchars( sstr_t *self, FILE *fp, int num_chars )
{
	int c = EOF;
	
	sstr_clear( self );
	while ( num_chars-- > 0 && (c = getc( fp )) != EOF )
		sstr_chcat( self, c );
		
	return c == EOF ? FALSE : TRUE;
}

/*-----------------------------------------------------------------------------
*   get one line from input, convert end-of-line sequences, 
*   return string including one LF character
*   return FALSE on end of input
*----------------------------------------------------------------------------*/
BOOL sstr_getline( sstr_t *self, FILE *fp )
{
	int c1, c2;
	
	sstr_clear( self );
	while ( (c1 = getc( fp )) != EOF && c1 != '\n' && c1 != '\r' )
		sstr_chcat( self, c1 );
	
	if ( c1 == EOF )
	{
		if ( sstr_len( self ) > 0 )			/* read some chars */
			sstr_chcat( self, '\n' );		/* missing newline at end of line */
	}
	else 						
	{
		sstr_chcat( self, '\n' );			/* end of line */
		
		if ( (c2 = getc( fp )) != EOF &&
			 ! ( c1 == '\n' && c2 == '\r' ||
				 c1 == '\r' && c2 == '\n' ) )
		{
			ungetc( c2, fp );				/* push back to input */
		}
	}
	
	return sstr_len( self ) > 0 ? TRUE : FALSE;
}

