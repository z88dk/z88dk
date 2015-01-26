/*
Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Paulo Custodio, 2011-2015

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/array.c,v 1.11 2015-01-26 23:46:22 pauloscustodio Exp $
*/

#include "xmalloc.h"		/* before any other include */

#include "array.h"

DEF_ARRAY( Byte );
DEF_ARRAY( UInt );
DEF_ARRAY( int );
DEF_ARRAY( long );
