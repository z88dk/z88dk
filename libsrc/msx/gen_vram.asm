;
;	z88dk library: Generic VDP support code
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: gen_vram.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_vram

	INCLUDE	"msx/vdp.inc"

msx_vram:
	ld	hl,VRAM_SIZE
	ret
