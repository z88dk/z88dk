;
;	z88dk library: Generic VDP support code
;
;	extern void vread(unsigned int source, void* dest, unsigned int count);
;
;	Transfer count bytes from VRAM to RAM
;

    SECTION code_video_vdp
    PUBLIC	vdp_vread
    PUBLIC	_vdp_vread

    EXTERN     SETRD

    INCLUDE	"video/tms9918/vdp.inc"


vdp_vread:
_vdp_vread:
	push	ix		;save callers ix
	ld      ix,4
	add     ix,sp



	ld e, (ix+2)	; dest
	ld d, (ix+3)
	
	ld l, (ix+4)	; source
	ld h, (ix+5)
	
	call	SETRD
	ex	(sp),hl		; VDP Timing
	ex	(sp),hl		; VDP Timing

	ld c, (ix+0)	; count
	ld b, (ix+1)

rdloop:
IF VDP_DATAIN < 0
	ld	a,(-VDP_DATAIN)
ELSE
	IF VDP_DATAIN > 256
		ld	a,(VDP_DATAIN / 256)
	ENDIF
	in	a,(VDP_DATAIN % 256)
ENDIF
	ld	(de),a
	inc	de
	dec	bc
	ld	a,c
	or	b
	jr	nz,rdloop
	pop	ix		;restore callers
	ret

