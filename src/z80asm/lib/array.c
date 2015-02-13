/*
Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Paulo Custodio, 2011-2015

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/array.c,v 1.12 2015-02-13 00:05:18 pauloscustodio Exp $
*/

#include "array.h"

DEF_ARRAY( Byte );
DEF_ARRAY( UInt );
DEF_ARRAY( int );
DEF_ARRAY( long );
