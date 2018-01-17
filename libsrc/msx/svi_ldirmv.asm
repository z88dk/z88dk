;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	LDIRMV
;
;
;	$Id: svi_ldirmv.asm$
;

        SECTION code_clib
	PUBLIC	LDIRMV
	PUBLIC	_LDIRMV
	
        INCLUDE "arch/svi/def/svi.def"
	
LDIRMV:
_LDIRMV:
	call	$3747	;SETRD
	ex	(sp),hl
	ex	(sp),hl

loop:
	in	a,(VDP_DATAIN)
	ld	(de),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
