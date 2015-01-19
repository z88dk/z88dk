;
;	z88dk library: Generic VDP support code
;
;	LIDRMV
;
;
;	$Id: gen_ldirmv.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	LIDRMV
	EXTERN		SETRD
	
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
