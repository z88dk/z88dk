;
;	z88dk library: Generic VDP support code
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: gen_vram.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	msx_vram

	INCLUDE	"msx/vdp.inc"

msx_vram:
	ld	hl,VRAM_SIZE
	ret
