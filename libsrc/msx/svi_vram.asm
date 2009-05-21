;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 29/05/2009
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: svi_vram.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_vram
		
msx_vram:
	ld	hl,16			; assume 16K
	ret
