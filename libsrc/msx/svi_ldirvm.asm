;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_ldirvm.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

	XLIB	LDIRVM
	
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
