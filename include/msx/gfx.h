/*=========================================================================

Compatibility headers for Z88DK

GFX - a small graphics library 

Copyright (C) 2004  Rafael de Oliveira Jannone


Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284


$Id: gfx.h,v 1.9 2014-05-02 08:10:24 stefano Exp $


=========================================================================*/

/*! \file gfx.h
    \brief main library functions
*/
// GFX.H : main library functions (header)

/* === WARNING ==

	This is a work-in-progress, meaning that most of this code is unstable
	and it's subject to future changes.  Also, most of it is very hackish,
	not properly cleaned up nor tested.

   === WARNING == */

#ifndef MSXGFX_H
#define MSXGFX_H


#include <msx/defs.h>
#include <stdlib.h>
#include <msx.h>
#include <string.h>
#include <graphics.h>
#include <psg.h>

// --- library functions / enums

/// @name Video
/// VRAM and VDP related functions
//@{

// VDP and VRAM functions

/// set screen mode
#define set_mode(mode) msx_set_mode(mode)

/// set screen to mangled mode (screen 1 + 2)
#define set_mangled_mode() msx_set_mangled_mode()

/// set screen color
#define set_color(front,back,border) msx_color(front,back,border)


// SORRY, WE HAVE A FUNCTION NAME CONFLICT.
// GET RID OF THE "DEFAULT" FILL FUNCTION (FILLS GRAPHICS AREA)
// AND DEFINE THE NEW ONE (VRAM FILL)

#undef fill

/// fill vram from \a addr, with \a value, for \a count bytes
#define fill(addr,value,count) msx_vfill(addr,value,count)


/// set \a value at a given vram address \a addr
#define vpoke(addr,value) msx_vpoke(addr,value)

/// get value from a given vram address \a addr
#define vpeek(addr) msx_vpeek(addr)

/// set \a value at a given vram address \a addr, merging bits (OR) with the existing value
#define vmerge(addr,value) msx_vmerge(addr,value)

/// transfer \a count bytes from ram to vram
#define vwrite(source,dest,count) msx_vwrite(source,dest,count)

/// transfer \a count bytes from vram to ram
#define vread(source,dest,count) msx_vread(source,dest,count)

/// set a vdp register with a \a value
#define set_vdp(reg,value) set_vdp_reg(reg,value) 

/// get a vdp value from register \a reg
#define get_vdp(reg) get_vdp_reg(reg)

/// move the screen cursor to a given position
#define locate(x,y) msx_locate(x,y)



// primitives (not many yet :))

/// vertical fill on vram starting at adress \a addr, of a given \a value, for \a count lines
#define fill_v(addr,value,count) msx_vfill_v(addr,value,count)



// mangled mode chars

/// set char \a c shape, from \a form, at the given screen map \a place
#define set_char_form(c,form,place) msx_set_char_form(c,form,place)

/// set char \a c attributes, from \a attr, at the given screen map \a place
#define set_char_attr(c,attr,place) msx_set_char_attr(c,attr,place)

/// set char \a c with \a color, at the given screen map \a place
#define set_char_color(c,color,place) msx_set_char_color(c,color,place) 

// set char \a c shape, attributes and color, all in one
#define set_char(c,form,attr,color,place) msx_set_char(c,form,attr,color,place)

//@}


/// @name Sprites
//@{


/// set the sprite \a mode
#define set_sprite_mode(mode) msx_set_sprite_mode(mode)

/*
// this is not compiling... I suggest some #define's instead

extern void *set_sprite(unsigned char, void*);
extern void *put_sprite(unsigned char, int, int, unsigned char, unsigned char);
*/

/// set the sprite \a handle, with the shape from \a data (small size)
#define set_sprite_8(handle,data) msx_set_sprite_8(handle,data)


/// set the sprite \a handle, with the shape from \a data (big size)
#define set_sprite_16(handle,data) msx_set_sprite_16(handle,data)

/// put the sprite with \a id and shape from \a handle, into the given position with \a color (small size)
#define put_sprite_8(id,x,y,handle,color) msx_put_sprite_8(id,x,y,handle,color)

/// put the sprite with \a id and shape from \a handle, into the given position with \a color (big size)
#define put_sprite_16(id,x,y,handle,color) msx_put_sprite_16(id,x,y,handle,color)

//@}


// surface
// FIXME: this is not usable right now

#define blit(source,dest,from,to) msx_blit(source,dest,from,to)
#define blit_ram_vram(source,dest,w,h,sjmp,djmp) msx_blit_ram_vram(source,dest,w,h,sjmp,djmp)
#define blit_fill_vram(dest,value,w,h,djmp) msx_blit_fill_vram(dest,value,w,h,djmp)


/// @name Controllers
//@{

/// get state of joystick number \a id
#define get_stick(x) msx_get_stick(x)

// get state of joystick button (trigger) number \a id, true = pressed
#define get_trigger(x) msx_get_trigger(x)

//@}


/// @name Random
/// Fast and dirty pseudo-random number generator
//@{

/// seed the pseudo-random number generator
#define seed_rnd(seed) srand(seed)

/// get the next number from the pseudo-random number generator
#define get_rnd() rand()

//@}


// alias for setting psg registers (for the BASIC fans)
#define sound(reg, value) set_psg(reg, value)

// set a psg register with a \a value
#define psg_set(reg, value) set_psg(reg, value)

// get value from psg register
#define psg_get(reg) get_psg(reg)


#endif

