;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_filvrm.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	FILVRM
	EXTERN		SETWRT
	
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
