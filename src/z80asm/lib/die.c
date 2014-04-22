/*
Exit with a fatal error, warn on stderr

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/die.c,v 1.4 2014-04-22 23:33:50 pauloscustodio Exp $
*/

#include "die.h"

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

/*-----------------------------------------------------------------------------
*   die()
*----------------------------------------------------------------------------*/
void die( char *msg, ... )
{
    va_list argptr;
    
	va_start( argptr, msg ); /* init variable args */
	vfprintf( stderr, msg, argptr );
	va_end( argptr );

    exit( 1 );
}

/*-----------------------------------------------------------------------------
*   warn()
*----------------------------------------------------------------------------*/
void warn( char *msg, ... )
{
    va_list argptr;
    
	va_start( argptr, msg ); /* init variable args */
    vfprintf( stderr, msg, argptr );
	va_end( argptr );
}

/*
* $Log: die.c,v $
* Revision 1.4  2014-04-22 23:33:50  pauloscustodio
* Allways call va_end() after va_start()
*
* Revision 1.3  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.2  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.1  2013/12/15 04:02:26  pauloscustodio
* Move the die and queue modules to the z80asm/lib directory
*
* Revision 1.12  2013/09/01 18:45:48  pauloscustodio
* comments
*
* Revision 1.11  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.10  2013/08/26 21:49:39  pauloscustodio
* Bug report 2013-07-27 10:50:27 by rkd77 : compile with -Wformat -Werror=format-security
*
* Revision 1.9  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.8  2012/06/14 15:01:27  pauloscustodio
* Split safe strings from strutil.c to safestr.c
*
* Revision 1.7  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.6  2012/05/24 15:07:03  pauloscustodio
* Rename safestr_t to sstr_t, keep length to speed-up appending chars
*
* Revision 1.5  2012/05/22 20:35:26  pauloscustodio
* astyle
*
* Revision 1.4  2012/05/22 20:29:17  pauloscustodio
* Use new sstr_t to simplify avoiding buffer overruns
*
* Revision 1.3  2012/05/20 06:39:27  pauloscustodio
* astyle
*
* Revision 1.2  2012/05/20 06:04:18  pauloscustodio
* die() with exception instead of exit(1)
*
* Revision 1.1  2012/05/17 14:40:39  pauloscustodio
* Exit with a fatal error, warn on stderr
*
*/
