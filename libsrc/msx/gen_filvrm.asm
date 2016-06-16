;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_filvrm.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
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
