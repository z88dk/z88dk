;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 29/05/2009
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: svi_vram.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_vram
		
msx_vram:
	ld	hl,16			; assume 16K
	ret
