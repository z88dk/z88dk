;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 29/05/2009
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: svi_vram.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vram
	PUBLIC	_msx_vram
		
msx_vram:
_msx_vram:
	ld	hl,16			; assume 16K
	ret
