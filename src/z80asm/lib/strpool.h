/*
Keep pool of strings for all duration of the program.
Most keywords in input program are the same, no need to keep several copies
and manage strdup/free for each token.
Strings with the same contents are reused.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strpool.h,v 1.4 2014-07-06 15:45:39 pauloscustodio Exp $
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
