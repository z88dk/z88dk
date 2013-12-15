/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Paulo Custodio, 2011-2013

Common types

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/types.h,v 1.14 2013-12-15 19:01:07 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include <stdio.h>					/* FILENAME_MAX */
#include <stdlib.h>					/* size_t */

/* BOOL type and constants */
typedef int BOOL;					/* FALSE and TRUE defined in glib.h */

#ifndef	FALSE
#define	FALSE	(0)
#endif

#ifndef	TRUE
#define	TRUE	(!FALSE)
#endif

/* Unsigned types */
typedef unsigned char byte_t;		/*  8-bit */
/* typedef unsigned int size_t;	*/	/* 32-bit */

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
* Revision 1.14  2013-12-15 19:01:07  pauloscustodio
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
* Replaced (unsigned char) by (byte_t)
* Replaced (unisigned int) by (size_t)
* Replaced (short) by (int)
*
* Revision 1.6  2013/01/20 21:10:32  pauloscustodio
* Rename bool to BOOL, to be consistent with TRUE and FALSE and
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
