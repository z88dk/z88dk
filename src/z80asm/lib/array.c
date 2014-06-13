/*
Template array that grows on request. Items may move in memory on reallocation.
Uses strutil.h for implementation.

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/array.c,v 1.9 2014-06-13 15:57:06 pauloscustodio Exp $
*/

#include "xmalloc.h"		/* before any other include */

#include "array.h"

DEF_ARRAY( Byte );
DEF_ARRAY( UInt );
DEF_ARRAY( int );
DEF_ARRAY( long );

/*
* $Log: array.c,v $
* Revision 1.9  2014-06-13 15:57:06  pauloscustodio
* Added UIntArray
*
* Revision 1.8  2014/06/09 13:15:27  pauloscustodio
* Int and UInt types
*
* Revision 1.7  2014/05/25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.6  2014/05/17 14:27:13  pauloscustodio
* Use C99 integer types
*
* Revision 1.5  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.4  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.3  2014/05/02 21:13:54  pauloscustodio
* Add byte array to default types
*
* Revision 1.2  2014/04/15 20:06:44  pauloscustodio
* Solve warning: no newline at end of file
*
* Revision 1.1  2014/04/12 15:18:05  pauloscustodio
* Add intArray and longArray to array.c
*
*
*/
