/*
Exit with a fatal error, warn on stderr

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/Attic/die.h,v 1.5 2014-01-25 20:19:35 pauloscustodio Exp $
*/

#pragma once

#include <assert.h>
#include <stdlib.h>

/* fatal error on stderr with printf-like argument */
extern void die( char *msg, ... );

/* warning on stderr with printf-like argument */
extern void warn( char *msg, ... );

/* OS-interface - assert no error */
#define xatexit(func) 	do { \
							int atexit_ret = atexit(func); \
							assert( atexit_ret == 0 ); \
						} while (0)

/*
* $Log: die.h,v $
* Revision 1.5  2014-01-25 20:19:35  pauloscustodio
* Use assert for failure
*
* Revision 1.4  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.3  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.2  2013/12/15 13:01:40  pauloscustodio
* Replace "if(1) { ... } else" in macro with "do { ... } while (0)" to avoid warning
* "suggest braces around empty body in an 'else' statement [-Wempty-body]"
*
* Revision 1.1  2013/12/15 04:02:26  pauloscustodio
* Move the die and queue modules to the z80asm/lib directory
*
* Revision 1.6  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.5  2013/01/20 21:24:28  pauloscustodio
* Updated copyright year to 2013
*
* Revision 1.4  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.3  2012/05/20 06:04:18  pauloscustodio
* die() with exception instead of exit(1)
*
* Revision 1.2  2012/05/17 15:10:47  pauloscustodio
* normalize constant for include-once #ifndef
*
* Revision 1.1  2012/05/17 14:40:39  pauloscustodio
* Exit with a fatal error, warn on stderr
*
*/
