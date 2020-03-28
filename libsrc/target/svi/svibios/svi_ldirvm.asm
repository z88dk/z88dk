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
	
        INCLUDE "target/svi/def/svi.def"
	
LDIRVM:
_LDIRVM:
	ex	de,hl
	call	$373C	;SETWRT

loop: 	ld	a,(de)
IF VDP_DATA < 0
	ld	(VDP_DATA),a
ELSE
	out	(VDP_DATA),a
ENDIF
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
