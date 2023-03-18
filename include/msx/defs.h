/*=========================================================================

Compatibility headers for Z88DK

GFX - a small graphics library 

Copyright (C) 2004  Rafael de Oliveira Jannone


Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284


$Id: defs.h,v $


=========================================================================*/

/*! \file defs.h
    \brief basic definitions and utilities
*/
// DEFS.H : shared defines


#ifndef MSXDEFS_H
#define MSXDEFS_H


#include <math.h>
#include <malloc.h>


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


// screen mapping

//extern unsigned int map_pixel(unsigned int x, unsigned int y);

/// maps a block in the screen 2 model
//xdefine map_block(x,y)        ((((y) & ~(7)) << 5) + ((x) & ~(7)))
extern int __LIB__ msx_map_m2_block(int x, int y) __smallc;
#define map_block(x,y)  msx_map_m2_block(x,y)

/// maps a pixel coordinate to a vram address
//xdefine map_pixel(x,y)        (map_block(x,y) + ((y) & 7))
extern int __LIB__ msx_map_m2_pixel(int x, int y) __smallc;
#define map_pixel(x,y)  msx_map_m2_pixel(x,y)

/*
        here is how it works:

        // map the row start (by row I mean a block of 8 lines)
        addr = (y & ~(7)) << 5;         // this is the same as (y / 8) * 256

        // then we aim for the column (column = block of 8 pixels)
        addr += (x & ~(7));     // this is the same as (x / 8) * 8

        // finally, aim for the remaining "sub-row" inside the row block
        addr += (y & 7);
*/

/// maps the subpixel (bit) inside the vram byte
#define map_subpixel(x) (128 >> ((x) & 7))
//extern int __LIB__  msx_map_m2_subpixel(int x) __z88dk_fastcall;
//xdefine map_subpixel(x)       msx_map_m2_subpixel(x)



#endif
