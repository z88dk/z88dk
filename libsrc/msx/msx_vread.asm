;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern void vread(unsigned int source, void* dest, unsigned int count);
;
;	Transfer count bytes from VRAM to RAM
;
;	$Id: msx_vread.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;


	XLIB	msx_vread
	
	LIB     msxbios
	
        INCLUDE "#msxbios.def"


msx_vread:

        ld      ix,2
        add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld e, (ix+2)	; dest
	ld d, (ix+3)

	ld l, (ix+4)	; source
	ld h, (ix+5)

	ld	ix,LDIRMV
	jp	msxbios
