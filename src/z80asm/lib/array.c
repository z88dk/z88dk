/*
Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/array.c,v 1.1 2014-04-12 15:18:05 pauloscustodio Exp $
*/

#include "xmalloc.h"		/* before any other include */

#include "array.h"

DEF_ARRAY( int );
DEF_ARRAY( long );

/*
* $Log: array.c,v $
* Revision 1.1  2014-04-12 15:18:05  pauloscustodio
* Add intArray and longArray to array.c
*
*
*/