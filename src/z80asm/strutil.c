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

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011

Utilities for string handling
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/strutil.c,v 1.3 2012-05-22 20:26:17 pauloscustodio Exp $ */
/* $Log: strutil.c,v $
/* Revision 1.3  2012-05-22 20:26:17  pauloscustodio
/* Safe strings
/* New type safestr_t to hold strings with size to prevent buffer overruns.
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
*   safestr_set, safestr_cat : return address of data
*----------------------------------------------------------------------------*/
char *safestr_set( safestr_t *self, char *source )
{
    safestr_clear( self );
    return safestr_cat( self, source );
}

char *safestr_cat( safestr_t *self, char *source )
{
    size_t  mylen = safestr_len( self );
    size_t  sourcelen = strlen( source );
    size_t  ncopy;

    if ( mylen + sourcelen + 1 >= self->size )
    {
        ncopy = self->size - mylen - 1;     /* truncate */
    }
    else
    {
        ncopy = sourcelen;                  /* full copy */
    }

    /* copy and null-terminate */
    memcpy( safestr_data( self ) + mylen, source, ncopy );
    safestr_data( self )[ mylen + ncopy ] = 0;

    return safestr_data( self );
}

/*-----------------------------------------------------------------------------
*   sprintf-like set / cat
*----------------------------------------------------------------------------*/
char *safestr_vfset( safestr_t *self, char *format, va_list argptr )
{
    safestr_clear( self );
    return safestr_vfcat( self, format, argptr );
}

char *safestr_vfcat( safestr_t *self, char *format, va_list argptr )
{
    size_t  mylen = safestr_len( self );
    int     ncopy;      /* may be negative */

    ncopy = self->size - ( mylen + 1 );

    if ( ncopy > 0 )
    {
        vsnprintf( safestr_data( self ) + mylen, ( size_t )ncopy, format, argptr );
    }

    return safestr_data( self );
}

char *safestr_fset( safestr_t *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    return safestr_vfset( self, format, argptr );
}

char *safestr_fcat( safestr_t *self, char *format, ... )
{
    va_list argptr;
    va_start( argptr, format ); /* init variable args */

    return safestr_vfcat( self, format, argptr );
}
