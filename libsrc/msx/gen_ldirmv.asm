;
;	z88dk library: Generic VDP support code
;
;	LIDRMV
;
;
;	$Id: gen_ldirmv.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	LIDRMV
	LIB		SETRD
	
	INCLUDE	"msx/vdp.inc"
	
LIDRMV:
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
