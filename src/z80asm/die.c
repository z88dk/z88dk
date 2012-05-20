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

Exit with a fatal error, warn on stderr
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/die.c,v 1.2 2012-05-20 06:04:18 pauloscustodio Exp $ */
/* $Log: die.c,v $
/* Revision 1.2  2012-05-20 06:04:18  pauloscustodio
/* die() with exception instead of exit(1)
/*
/* Revision 1.1  2012/05/17 14:40:39  pauloscustodio
/* Exit with a fatal error, warn on stderr
/*
/*
/* */

#include "memalloc.h"  /* before any other include */
#include "die.h"
#include "types.h"

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

/*-----------------------------------------------------------------------------
*   die()
*----------------------------------------------------------------------------*/
void die( e4c_exception_type exception, char *msg, ... )
{
    va_list argptr;
	char errstr[MAXLINE];

    va_start( argptr, msg ); /* init variable args */

	vsnprintf( errstr, sizeof(errstr)-1, msg, argptr );
    fprintf( stderr, errstr );
    throw( exception, errstr );
}

/*-----------------------------------------------------------------------------
*   warn()
*----------------------------------------------------------------------------*/
void warn( char *msg, ... )
{
    va_list argptr;
    va_start( argptr, msg ); /* init variable args */

    vfprintf( stderr, msg, argptr );
}
