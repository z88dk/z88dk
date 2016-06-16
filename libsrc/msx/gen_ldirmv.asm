;
;	z88dk library: Generic VDP support code
;
;	LIDRMV
;
;
;	$Id: gen_ldirmv.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	LIDRMV
	PUBLIC	_LIDRMV
	EXTERN		SETRD
	
	INCLUDE	"msx/vdp.inc"
	
LIDRMV:
_LIDRMV:
	call	SETRD
	ex	(sp),hl
	ex	(sp),hl

loop:
	in	a,(VDP_DATAIN)
	ld	(de),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
