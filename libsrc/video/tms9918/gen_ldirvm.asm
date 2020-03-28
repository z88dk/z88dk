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
	
	INCLUDE	"video/tms9918/vdp.inc"
	
LDIRVM:
_LDIRVM:
	ex	de,hl
	push	bc
	call	SETWRT
	pop		hl
IF VDP_DATA >= 0
	ld		bc,VDP_DATA
ENDIF
loop: 	
	ld	a,(de)
IF VDP_DATA < 0
	ld	(-VDP_DATA),a
ELSE
	out	(c),a
ENDIF
	inc	de
	dec	hl
	ld	a,h
	or	l
	jr	nz,loop
	ret
