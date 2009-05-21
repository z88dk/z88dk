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
;	$Id: msx_locate.asm,v 1.4 2009-05-21 06:58:11 stefano Exp $
;


	XLIB	msx_locate
	
	LIB	msxbios

IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
ENDIF


msx_locate:
	
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	
	ld	h,e

	ld	ix,POSIT
	jp	msxbios
