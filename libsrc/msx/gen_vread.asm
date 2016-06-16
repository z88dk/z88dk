;
;	z88dk library: Generic VDP support code
;
;	extern void vread(unsigned int source, void* dest, unsigned int count);
;
;	Transfer count bytes from VRAM to RAM
;
;	$Id: gen_vread.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vread
	PUBLIC	_msx_vread
	EXTERN     SETRD
	
	INCLUDE	"msx/vdp.inc"


msx_vread:
_msx_vread:
	push	ix		;save callers ix
	ld      ix,4
	add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld e, (ix+2)	; dest
	ld d, (ix+3)
	
	ld l, (ix+4)	; source
	ld h, (ix+5)
	
	;ld	ix,LDIRMV
	;jp	msxbios

	call	SETRD
	ex	(sp),hl		; VDP Timing
	ex	(sp),hl		; VDP Timing

rdloop:
	in	a,(VDP_DATAIN)
	ld	(de),a
	inc	de
	dec	bc
	ld	a,c
	or	b
	jr	nz,rdloop
	pop	ix		;restore callers
	ret

