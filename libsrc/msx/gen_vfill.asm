;
;	z88dk library: Generic VDP support code
;
;	extern void msx_vfill(unsigned int addr, unsigned char value, unsigned int count);
;
;	Fills a VRAM portion with the given value
;
;	$Id: gen_vfill.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;


	XLIB	msx_vfill
	LIB     FILVRM
	
	INCLUDE	"msx/vdp.inc"


msx_vfill:

	ld      ix,2
	add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld a, (ix+2)	; value

	ld l, (ix+4)	; addr
	ld h, (ix+5)

	jp	FILVRM
