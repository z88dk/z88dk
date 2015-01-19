;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_ldirvm.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	LDIRVM
	EXTERN		SETWRT
	
	INCLUDE	"msx/vdp.inc"
	
LDIRVM:
	ex	de,hl
	call	SETWRT

loop: 	ld	a,(de)
	out	(VDP_DATA),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
