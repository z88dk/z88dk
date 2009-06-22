;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_filvrm.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

	XLIB	FILVRM
	
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
