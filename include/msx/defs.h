/*=========================================================================

Compatibility headers for Z88DK

GFX - a small graphics library 

Copyright (C) 2004  Rafael de Oliveira Jannone


Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284


$Id: defs.h,v 1.1 2009-01-07 09:50:15 stefano Exp $


=========================================================================*/

/*! \file defs.h
    \brief basic definitions and utilities
*/
// DEFS.H : shared defines

/* === WARNING ==

	This is a work-in-progress, meaning that most of this code is unstable
	and it's subject to future changes.  Also, most of it is very hackish,
	not properly cleaned up nor tested.

   === WARNING == */

#ifndef MSXDEFS_H
#define MSXDEFS_H


#include <math.h>
#include <malloc.h>


// HTC compatibility

#define putch(chr)	fputc_cons(chr)


// trivial stuff

#define u_int	unsigned int
#define u_char	unsigned char

#ifndef bool
	#define bool	char
#endif

#ifndef true
	#define true	1
#endif

#ifndef false
	#define false	0
#endif

#ifndef NULL
	#define NULL 0
#endif


#define LONG(v)	((long)(v))

// fixed point arithmetic

/// integer to fixed-point
#define i2f(v)	((v) << 6)
//#define i2f(v)	((v) * 10000)

/// fixed-point to integer
#define f2i(v)	((v) >> 6)
//#define f2i(v)	((v) / 10000)

/// fixed-point multiplication
#define mulfx(x,y)	((LONG(y) * LONG(x)) >> 6)
//#define mulfx(x,y)	((LONG(y) * LONG(x)) / 10000)

/// fixed-point division
#define divfx(x,y)	((LONG(x) << 6) / LONG(y))
//#define divfx(x,y)	((LONG(x) * 10000) / LONG(y))

/// fixed-point square
#define sqrfx(x)	((LONG(x) * LONG(x)) >> 6)
//#define sqrfx(x)	((LONG(x) * LONG(x)) / 10000)

/// fixed-point square root
#define sqrtfx(x)	(LONG(sqrt(x)) << 3)
//#define sqrtfx(x)	(LONG(sqrt(x)) * 100)
// formula: sqrt(N * 64) = sqrt(N) * sqrt(64) -> must compensate with 64/sqrt(64) = 8

/// weighted average (w=0.0 -> x, w=0.5->average, w=1.0 ->y)
#define wgavgfx(x, y, w)	(mulfx(i2f(1) - w, x) + mulfx(w, y))

// malloc helpers

/// allocates space for 1 element of type \a x
#define new(x)		((x*)malloc(sizeof(x)))

/// allocates space for \a c elements of type \a x
#define newa(x, c)	((x*)malloc(sizeof(x) * c))

#endif
