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
	
        INCLUDE "target/svi/def/svi.def"
	
LDIRMV:
_LDIRMV:
	call	$3747	;SETRD
	ex	(sp),hl
	ex	(sp),hl

loop:
IF VDP_DATAIN < 0
	ld	a,(VDP_DATAIN)
ELSE
	in	a,(VDP_DATAIN)
ENDIF
	ld	(de),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
