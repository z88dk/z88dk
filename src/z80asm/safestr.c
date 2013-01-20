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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/safestr.c,v 1.3 2013-01-20 21:24:28 pauloscustodio Exp $ */
/* $Log: safestr.c,v $
/* Revision 1.3  2013-01-20 21:24:28  pauloscustodio
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

#include <string.h>
#include <ctype.h>
#include "safestr.h"

#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "types.h"

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
