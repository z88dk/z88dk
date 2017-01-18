/*
	Minimal Xlib port - Internal functions
	Return a pointer to the graphics definition of the given char (ASCII code - 32)
	
	Stefano Bodrato, 5/3/2007
	
	$Id: _xfindchar.c,v 1.1 2007-12-21 08:04:23 stefano Exp $
*/

#define _BUILDING_X
#include <X11/Xlib.h>

char *_xfindchar (char c, char *font)
{
#asm
	pop	de	; ret address
	pop	hl	; char *font
	pop	bc	; char c
	push	bc
	push	hl
	push	de
	ld	a,c
	and	a
	jr	z,gotchar
next_char:
	ld	a,(hl)
	and	a
	jr	nz,no_end
	ld	hl,-1
	ret
no_end:
	inc	hl
	dec	a
	srl	a
	srl	a
	srl	a
	ld	b,a
	and	a	; set flag
	ld	a,(hl)
	inc	hl
	ld	e,a
	ld	d,0
	add	hl,de	; flag is left unchanged
	jr	z,noloop
byteloop:
	add	hl,de
	djnz	byteloop
noloop:
	dec	c
	jr	nz,next_char
gotchar:
#endasm
}
