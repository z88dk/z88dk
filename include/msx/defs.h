/*=========================================================================

Compatibility headers for Z88DK

GFX - a small graphics library 

Copyright (C) 2004  Rafael de Oliveira Jannone


Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284


$Id: defs.h,v 1.4 2009-04-15 21:00:57 stefano Exp $


=========================================================================*/

/*! \file defs.h
    \brief basic definitions and utilities
*/
// DEFS.H : shared defines


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


// malloc helpers

/// allocates space for 1 element of type \a x
#define new(x)		((x*)malloc(sizeof(x)))

/// allocates space for \a c elements of type \a x
#define newa(x, c)	((x*)malloc(sizeof(x) * c))

#endif
