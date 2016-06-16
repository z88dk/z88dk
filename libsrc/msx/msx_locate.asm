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
;	$Id: msx_locate.asm,v 1.7 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_locate
	PUBLIC	_msx_locate
	
	EXTERN	msxbios

IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


msx_locate:
_msx_locate:
	
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	
	ld	h,e
	push	ix
	ld	ix,POSIT
	call	msxbios
	pop	ix
	ret
