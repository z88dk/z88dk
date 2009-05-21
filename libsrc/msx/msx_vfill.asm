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
;	$Id: msx_vfill.asm,v 1.2 2009-05-21 06:58:11 stefano Exp $
;


	XLIB	msx_vfill
	
	LIB	msxbios

	
IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
ENDIF


msx_vfill:
	
        ld      ix,2
        add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld a, (ix+2)	; value

	ld l, (ix+4)	; addr
	ld h, (ix+5)

	ld ix,FILVRM
	jp msxbios
