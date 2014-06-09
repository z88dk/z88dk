/*
Common types and macros

Copyright (C) Paulo Custodio, 2011-2014

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/types.h,v 1.12 2014-06-09 13:15:27 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"	/* before any other include */

#include <stdio.h>		/* FILENAME_MAX */
#include <stdint.h>

/* Integer types */
typedef uint8_t  Byte;
typedef uint32_t UInt;
typedef int32_t  Int;

/* Bool type and constants */
typedef int Bool;

#ifndef	FALSE
#define	FALSE	(0)
#endif

#ifndef	TRUE
#define	TRUE	(!FALSE)
#endif

/* MIN, MAX, ABS, CLAMP */
#undef	MIN
#define MIN(a, b)  (((a) < (b)) ? (a) : (b))

#undef	MAX
#define MAX(a, b)  (((a) > (b)) ? (a) : (b))

#undef	ABS
#define ABS(a)	   (((a) < 0) ? -(a) : (a))

#undef	CLAMP
#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

/* number of elements of array */
#define NUM_ELEMS(a)		((int) (sizeof(a) / sizeof((a)[0])))

/* maximum length of strings, must be at least FILENAME_MAX */
#define MAXLINE			MAX( 1024, FILENAME_MAX )

/*
* $Log: types.h,v $
* Revision 1.12  2014-06-09 13:15:27  pauloscustodio
* Int and UInt types
*
* Revision 1.11  2014/05/25 01:02:30  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.10  2014/05/17 14:27:13  pauloscustodio
* Use C99 integer types
*
* Revision 1.9  2014/05/06 22:17:38  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.8  2014/05/06 16:32:23  dom
* Get the protector in the right place
*
* Revision 1.7  2014/05/05 21:51:30  dom
* Horrible workaround.
*
* Revision 1.6  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, UInt
*
* Revision 1.5  2014/03/05 23:44:55  pauloscustodio
* Renamed 64-bit portability to BUG_0042
*
* Revision 1.4  2014/02/19 23:59:27  pauloscustodio
* BUG_0042: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create UInt, use UInt instead of size_t.
*
* Revision 1.3  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.2  2014/01/05 23:22:58  pauloscustodio
* comment
*
* Revision 1.1  2013/12/15 19:04:32  pauloscustodio
* Move types.h to the z80asm/lib directory
*
* Revision 1.14  2013/12/15 19:01:07  pauloscustodio
* Move platform specific defines from types.h to config.h.
* Remove dependency of types.h from glib.h.
* Use NUM_ELEMS() instead of glib G_N_ELEMENTS().
*
* Revision 1.13  2013/12/15 13:18:34  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.12  2013/09/01 18:45:35  pauloscustodio
* Remove NUM_ELEMS, use G_N_ELEMENTS instead (from glib.h)
* Remove FALSE, TRUE, MIN, MAX; defined in glib.h
*
* Revision 1.11  2013/09/01 11:59:05  pauloscustodio
* Force xmalloc to be the first include, to be able to use MSVC memory debug tools
*
* Revision 1.10  2013/05/12 19:23:17  pauloscustodio
* MAXIDENT for maximum identifier length - set at 255 because of object file format
* with one byte string length
* MIN and MAX macros
*
* Revision 1.9  2013/05/01 22:24:28  pauloscustodio
* Make sure MAXLINE is >= FILENAME_MAX
*
* Revision 1.8  2013/04/21 22:51:03  pauloscustodio
* Include io.h only in MSVC
*
* Revision 1.7  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (Byte)
* Replaced (unisigned int) by (UInt)
* Replaced (short) by (int)
*
* Revision 1.6  2013/01/20 21:10:32  pauloscustodio
* Rename bool to Bool, to be consistent with TRUE and FALSE and
* distinguish from C++ bool, true, false
*
* Revision 1.5  2012/06/14 15:03:13  pauloscustodio
* Use _MSC_VER instead of WIN32 for MS-C compiler specific code
*
* Revision 1.4  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.3  2012/05/20 05:59:18  pauloscustodio
* Add MAXLINE, WIN32 versions of snprintf, vsnprintf
*
* Revision 1.2  2012/05/17 15:10:47  pauloscustodio
* normalize constant for include-once #ifndef
*
* Revision 1.1  2012/05/17 14:45:22  pauloscustodio
* Common types
*
*/
