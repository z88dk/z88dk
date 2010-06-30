;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_filvrm.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	FILVRM
	LIB		SETWRT
	
	INCLUDE	"msx/vdp.inc"
	
FILVRM:
	push	af
	call	SETWRT

loop: 	pop	af
	out	(VDP_DATA),a
	push	af
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	pop	af
	ret
