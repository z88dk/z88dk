;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_ldirvm.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
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
