;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_ldirvm.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	LDIRVM
	PUBLIC	_LDIRVM
	EXTERN		SETWRT
	
	INCLUDE	"msx/vdp.inc"
	
LDIRVM:
_LDIRVM:
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
