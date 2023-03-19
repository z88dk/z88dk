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
	
	INCLUDE	"video/tms9918/vdp.inc"
	
LDIRMV:
_LDIRMV:
	push	bc
	call	SETRD
	pop		bc	
	ex	(sp),hl		;Timing
	ex	(sp),hl

loop:
IF VDP_DATAIN < 0
	ld	a,(-VDP_DATAIN)
ELSE
	IF VDP_DATAIN > 255
		ld	a,VDP_DATAIN / 256
	ENDIF
	in	a,(VDP_DATAIN % 256)
ENDIF
	ld	(de),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	ret
