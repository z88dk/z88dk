/*=========================================================================

Compatibility headers for Z88DK

GFX - a small graphics library 

Copyright (C) 2004  Rafael de Oliveira Jannone


Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284


$Id: 3d.h,v 1.1 2009-04-15 21:00:57 stefano Exp $


=========================================================================*/

/*! \file 3d.h
    \brief vector math and 3d graphics
*/
// 3D.H : 3D graphics and vectors functions (header)

/* NOTE:

     1)  All the z88dk 3D related code is in "lib3d.h".
         This file is just kept for comaptibility reasons.
         
     2)  The lookup tables are not necessary with z88dk
*/



#ifndef MSX3D_H
#define MSX3D_H

#include <msx/gfx.h>
#include <lib3d.h>

/// lookup cosine table
//--extern int *tcos;

/// lookup sine table
//--extern int *tsin;

/// create the lookup tables for cos and sin. you MUST call this before operating on vectors.
//void create_lookup_tables();
#define create_lookup_tables() asm("nop\n");

/// deallocate the lookup tables
//void destroy_lookup_tables();
#define destroy_lookup_tables() asm("nop\n");


#endif
