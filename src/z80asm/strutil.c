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

Copyright (C) Paulo Custodio, 2011-2012

Utilities for string handling
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strutil.c,v 1.7 2012-05-26 17:46:00 pauloscustodio Exp $ */
/* $Log: strutil.c,v $
/* Revision 1.7  2012-05-26 17:46:00  pauloscustodio
/* Put back strtoupper, strupr does not exist in all systems, was causing nightly build to fail
/*
/* Revision 1.6  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.5  2012/05/24 17:00:43  pauloscustodio
/* astyle
/*
/* Revision 1.4  2012/05/24 15:07:03  pauloscustodio
/* Rename safestr_t to sstr_t, keep length to speed-up appending chars
/*
/* Revision 1.3  2012/05/22 20:26:17  pauloscustodio
/* Safe strings
/* New type sstr_t to hold strings with size to prevent buffer overruns.
/* Remove strtoupper, use POSIX strupr instead
/*
/* Revision 1.2  2012/05/11 19:29:49  pauloscustodio
/* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
/*         --mode=c
/*         --lineend=linux
/*         --indent=spaces=4
/*         --style=ansi --add-brackets
/*         --indent-switches --indent-classes
/*         --indent-preprocessor --convert-tabs
/*         --break-blocks
/*         --pad-oper --pad-paren-in --pad-header --unpad-paren
/*         --align-pointer=name
/*
/* Revision 1.1  2011/10/14 13:48:05  pauloscustodio
/* String utilities
/*
/*
/* */

#include <string.h>
#include <ctype.h>
#include "strutil.h"

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

    ncopy = self->size - ( mylen + 1 );

    if ( ncopy > 0 )
    {
        /* returns number of chars written, or -1 if output truncated */
        copied = vsnprintf( sstr_data( self ) + mylen, ( size_t )ncopy, format, argptr );

        if ( copied >= 0 )
        {
            sstr_len( self ) += copied;
        }
        else
        {
            sstr_sync_len( self );
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
*   convert string to upper/lower case
*----------------------------------------------------------------------------*/
char *strtoupper( char *string )
{
    char *p;

    for ( p = string; *p; p++ )
    {
        *p = toupper( *p );
    }

    return string;
}

char *strtolower( char *string )
{
    char *p;

    for ( p = string; *p; p++ )
    {
        *p = tolower( *p );
    }

    return string;
}
