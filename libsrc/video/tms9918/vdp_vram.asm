;
;	z88dk library: Generic VDP support code
;
;	int vdp_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: gen_vram.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_video_vdp
	PUBLIC	vdp_vram
	PUBLIC	_vdp_vram

	INCLUDE	"video/tms9918/vdp.inc"

vdp_vram:
_vdp_vram:
	ld	hl,VRAM_SIZE
	ret
