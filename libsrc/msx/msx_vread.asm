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
;	$Id: msx_vread.asm,v 1.5 2009-06-22 21:44:17 dom Exp $
;


	XLIB	msx_vread
	
	LIB     msxbios
	

IF FORmsx
        INCLUDE "msxbios.def"
        INCLUDE "msx.def"
ELSE
        INCLUDE "svibios.def"
        INCLUDE "svi.def"
ENDIF


msx_vread:

        ld      ix,2
        add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld e, (ix+2)	; dest
	ld d, (ix+3)
	
	ld l, (ix+4)	; source
	ld h, (ix+5)
	
	;ld	ix,LDIRMV
	;jp	msxbios

	ld	ix,SETRD
	call	msxbios
	ex	(sp),hl		; VDP Timing
	ex	(sp),hl		; VDP Timing

rdloop:
	in	a,(VDP_DATAIN)
	ld	(de),a
	inc	de
	dec	bc
	ld	a,c
	or	b
	jr	nz,rdloop
	ret

