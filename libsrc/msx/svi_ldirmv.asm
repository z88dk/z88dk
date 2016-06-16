;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	LIDRMV
;
;
;	$Id: svi_ldirmv.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	LIDRMV
	
        INCLUDE "svi.def"
	
LIDRMV:
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
