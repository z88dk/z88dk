;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_filvrm.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
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
