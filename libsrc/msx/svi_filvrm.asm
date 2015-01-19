;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_filvrm.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	FILVRM
	
        INCLUDE "svi.def"
	
FILVRM:
	push	af
	call	$373C	;SETWRT

loop: 	pop	af
	out	(VDP_DATA),a
	push	af
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	pop	af
	ret
