;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 29/05/2009
;
;	int vdp_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: svi_vram.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_vram
	PUBLIC	_vdp_vram
		
vdp_vram:
_vdp_vram:
	ld	hl,16			; assume 16K
	ret
