;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	Adapted to z88dk by Stefano Bodrato
;
;	extern void msx_locate(unsigned char x, unsigned char y);
;
;	Move the screen cursor to a given position
;
;	$Id: msx_locate.asm,v 1.2 2009-01-13 17:48:01 stefano Exp $
;


	XLIB	msx_locate
	
	LIB	msxbios

        INCLUDE "#msxbios.def"


msx_locate:
	
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	
	ld	h,e

	ld	ix,POSIT
	jp	msxbios
