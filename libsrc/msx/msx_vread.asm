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
;	$Id: msx_vread.asm,v 1.7 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vread
	PUBLIC	_msx_vread
	
	EXTERN     msxbios
	

IF FORmsx
        INCLUDE "msxbios.def"
        INCLUDE "msx.def"
ELSE
        INCLUDE "svibios.def"
        INCLUDE "svi.def"
ENDIF


msx_vread:
_msx_vread:
	push	ix

        ld      ix,4
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
	pop	ix
	ret

