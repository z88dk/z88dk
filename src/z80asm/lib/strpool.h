/*
Keep pool of strings for all duration of the program.
Strings with the same contents are reused, and hash tables can use string address
as key instead of whole string - quicker for long strings.

Copyright (C) Paulo Custodio, 2011-2015

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/strpool.h,v 1.6 2015-02-22 13:46:35 pauloscustodio Exp $
*/

#pragma once

/* initialize module; called automatically by strpool_add(), but may be needed to force
*  initialization in a module that uses the pool, to make sure destruction is in the correct order 
*  (first module, then pool)
*/
extern void strpool_init( void );

/* check if the given string exists in the pool, return string address if found, NULL if not.
*  does not add the string to the pool
*/
extern char *strpool_exists(char *str);

/* If the given string exists in the pool, return pointer to it.
*  Else copies it to the pool and returns pointer.
*  Accepts and returns a NULL pointer.
*/
extern char *strpool_add( char *str );
