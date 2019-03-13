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
	
        INCLUDE "target/svi/def/svi.def"
	
FILVRM:
	push	af
	call	$373C	;SETWRT

loop: 	pop	af
IF VDP_DATA < 0
	ld	(VDP_DATA),a
ELSE
	out	(VDP_DATA),a
ENDIF
	push	af
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	pop	af
	ret
