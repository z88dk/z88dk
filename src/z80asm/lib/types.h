/*
Common types and macros

Copyright (C) Paulo Custodio, 2011-2015

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/lib/types.h,v 1.16 2015-02-22 02:44:33 pauloscustodio Exp $
*/

#pragma once

#include <stdio.h>			/* FILENAME_MAX */

#ifdef _MSC_VER
#define snprintf _snprintf
#define vsnprintf _vsnprintf
#endif

/* Integer types */
typedef unsigned char Byte;
typedef int 		  Bool;

#ifndef	FALSE
#define	FALSE	(0)
#endif

#ifndef	TRUE
#define	TRUE	(!FALSE)
#endif

/* MIN, MAX, ABS, CLAMP */
#undef	MIN
#define MIN(a, b)  		(((a) < (b)) ? (a) : (b))

#undef	MAX
#define MAX(a, b)  		(((a) > (b)) ? (a) : (b))

#undef	ABS
#define ABS(a)	   		(((a) < 0) ? -(a) : (a))

#undef	CLAMP
#define CLAMP(x, low, high)  \
						(((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

/* number of elements of array */
#define NUM_ELEMS(a)	((int) (sizeof(a) / sizeof((a)[0])))

/* maximum length of strings, must be at least FILENAME_MAX */
#define MAXLINE			MAX( 1024, FILENAME_MAX )
