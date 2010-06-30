;
;	z88dk library: Generic VDP support code
;
;	FILVRM
;
;
;	$Id: gen_ldirvm.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	LDIRVM
	LIB		SETWRT
	
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
