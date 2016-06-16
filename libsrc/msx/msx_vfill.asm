;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern void msx_vfill(unsigned int addr, unsigned char value, unsigned int count);
;
;	Fills a VRAM portion with the given value
;
;	$Id: msx_vfill.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vfill
	PUBLIC	_msx_vfill
	
	EXTERN	msxbios

	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


msx_vfill:
_msx_vfill:
	push	ix	
        ld      ix,4
        add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld a, (ix+2)	; value

	ld l, (ix+4)	; addr
	ld h, (ix+5)

	ld ix,FILVRM
	call	msxbios
	pop	ix
	ret
