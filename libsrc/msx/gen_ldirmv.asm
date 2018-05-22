;
;	z88dk library: Generic VDP support code
;
;	LDIRMV
;
;
;	$Id: gen_ldirmv.asm$
;

        SECTION code_clib
	PUBLIC	LDIRMV
	PUBLIC	_LDIRMV
	EXTERN		SETRD
	
	INCLUDE	"msx/vdp.inc"
	
LDIRMV:
_LDIRMV:
	call	SETRD
	ex	(sp),hl
	ex	(sp),hl

loop:
IF VDP_DATAIN > 255
	ld	a,(VDP_DATAIN)
ELSE
	in	a,(VDP_DATAIN)
ENDIF
	ld	(de),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
