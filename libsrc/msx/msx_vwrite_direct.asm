;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern void msx_vwrite_direct(void *source, u_int dest, u_int count)
;
;	Transfer count bytes from RAM (current memory page) to VRAM
;
;	$Id: msx_vwrite_direct.asm,v 1.6 2009-06-22 21:44:17 dom Exp $
;


	XLIB	msx_vwrite_direct
	
	LIB     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
        INCLUDE "msx.def"
ELSE
        INCLUDE "svibios.def"
        INCLUDE "svi.def"
ENDIF


msx_vwrite_direct:

        ld      ix,2
        add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld l, (ix+2)	; dest
	ld h, (ix+3)

	ld e, (ix+4)	; source
	ld d, (ix+5)

	ld	ix,SETWRT
	call	msxbios

wrtloop:
	ld	a,(de)
	out	(VDP_DATA),a
	inc	de
	dec	bc
	ld	a,c
	or	b
	jr	nz,wrtloop
	ret

