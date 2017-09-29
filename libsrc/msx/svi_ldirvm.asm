;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	LDIRVM
;
;
;	$Id: svi_ldirvm.asm$
;

        SECTION code_clib
	PUBLIC	LDIRVM
	PUBLIC	_LDIRVM
	
        INCLUDE "svi.def"
	
LDIRVM:
_LDIRVM:
	ex	de,hl
	call	$373C	;SETWRT

loop: 	ld	a,(de)
	out	(VDP_DATA),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
