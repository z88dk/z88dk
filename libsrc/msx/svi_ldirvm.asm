;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_ldirvm.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	LDIRVM
	
        INCLUDE "svi.def"
	
LDIRVM:
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
