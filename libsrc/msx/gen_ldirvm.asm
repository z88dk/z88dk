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
IF VDP_DATA > 255
	ld	(VDP_DATA),a
ELSE
	out	(VDP_DATA),a
ENDIF
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
