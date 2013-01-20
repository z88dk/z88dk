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

Exit with a fatal error, warn on stderr
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/die.c,v 1.9 2013-01-20 21:24:28 pauloscustodio Exp $ */
/* $Log: die.c,v $
/* Revision 1.9  2013-01-20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.8  2012/06/14 15:01:27  pauloscustodio
/* Split safe strings from strutil.c to safestr.c
/*
/* Revision 1.7  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.6  2012/05/24 15:07:03  pauloscustodio
/* Rename safestr_t to sstr_t, keep length to speed-up appending chars
/*
/* Revision 1.5  2012/05/22 20:35:26  pauloscustodio
/* astyle
/*
/* Revision 1.4  2012/05/22 20:29:17  pauloscustodio
/* Use new sstr_t to simplify avoiding buffer overruns
/*
/* Revision 1.3  2012/05/20 06:39:27  pauloscustodio
/* astyle
/*
/* Revision 1.2  2012/05/20 06:04:18  pauloscustodio
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
#include "strutil.h"
#include "safestr.h"

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

/*-----------------------------------------------------------------------------
*   die()
*----------------------------------------------------------------------------*/
void die( e4c_exception_type exception, char *msg, ... )
{
    va_list argptr;
    SSTR_DEFINE( errstr, MAXLINE );

    va_start( argptr, msg ); /* init variable args */

    sstr_vfset( errstr, msg, argptr );   /* build message */

    fprintf( stderr, sstr_data( errstr ) );
    throw( exception, sstr_data( errstr ) );
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
