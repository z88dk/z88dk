;
;	z88dk library: Generic VDP support code
;
;	extern void msx_vwrite(void *source, u_int dest, u_int count)
;
;	Transfer count bytes from RAM to VRAM (BIOS paged version)
;
;	$Id: gen_vwrite.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vwrite
	PUBLIC	_msx_vwrite
	EXTERN     LDIRVM
	
	INCLUDE	"msx/vdp.inc"


msx_vwrite:
_msx_vwrite:
	push	ix		;save callers
	ld      ix,4
	add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld e, (ix+2)	; dest
	ld d, (ix+3)
	
	ld l, (ix+4)	; source
	ld h, (ix+5)
	
	call	LDIRVM
	pop	ix	; resotre callers
	ret
	
