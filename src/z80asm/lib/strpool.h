/*
Keep pool of strings for all duration of the program.
Most keywords in input program are the same, no need to keep several copies
and manage strdup/free for each token.
Strings with the same contents are reused.

Copyright (C) Paulo Custodio, 2011-2013

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strpool.h,v 1.2 2014-01-11 00:10:39 pauloscustodio Exp $
*/

#pragma once

/* If the given string exists in the pool, return pointer to it.
   Else copies it to the pool and returns pointer.
   Accepts and returns a NULL pointer.
*/
extern char *strpool_add( char *str );

/* initialize module; called automatically by strpool_add(), but may be needed to force
   initialization on the T_init() function of a class that uses the pool, to make sure
   destruction is in the correct order (first T, then pool)
*/
extern void strpool_init( void );

/*
* $Log: strpool.h,v $
* Revision 1.2  2014-01-11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.1  2013/12/18 01:46:22  pauloscustodio
* Move strpool.c to the z80asm/lib directory
*
* Revision 1.2  2013/01/19 01:33:16  pauloscustodio
* Clean-up strpool code
*
* Revision 1.1  2012/05/24 17:50:02  pauloscustodio
* CH_0010 : new string pool to hold strings for all program duration
*
*/
