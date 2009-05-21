;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	FILVRM
;
;
;	$Id: svi_filvrm.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	FILVRM
	
        INCLUDE "#svi.def"
	
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
