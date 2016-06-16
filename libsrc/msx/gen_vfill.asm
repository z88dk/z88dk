;
;	z88dk library: Generic VDP support code
;
;	extern void msx_vfill(unsigned int addr, unsigned char value, unsigned int count);
;
;	Fills a VRAM portion with the given value
;
;	$Id: gen_vfill.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;


        SECTION code_clib
	PUBLIC	msx_vfill
	PUBLIC	_msx_vfill
	EXTERN     FILVRM
	
	INCLUDE	"msx/vdp.inc"


msx_vfill:
_msx_vfill:

	ld      ix,2
	add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld a, (ix+2)	; value

	ld l, (ix+4)	; addr
	ld h, (ix+5)

	jp	FILVRM
