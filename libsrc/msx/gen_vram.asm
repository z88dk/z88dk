;
;	z88dk library: Generic VDP support code
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: gen_vram.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vram
	PUBLIC	_msx_vram

	INCLUDE	"msx/vdp.inc"

msx_vram:
_msx_vram:
	ld	hl,VRAM_SIZE
	ret
