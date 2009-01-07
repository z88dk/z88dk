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
;	Fills a VRAM portion with the given value
;
;	$Id: msx_locate.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
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
