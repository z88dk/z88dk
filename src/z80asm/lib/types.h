/*
Z88DK Z80 Macro Assembler

Common types and macros

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#pragma once

#include <stdio.h>			/* FILENAME_MAX */
#include <stdint.h>

#ifdef _MSC_VER
#define snprintf _snprintf
#define vsnprintf _vsnprintf
#endif

/* Integer types */
typedef uint8_t		Byte;
typedef uint16_t	Word;
typedef int 		Bool;

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
