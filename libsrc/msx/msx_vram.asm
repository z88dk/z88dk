;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int msx_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: msx_vram.asm,v 1.1 2007-12-03 07:29:40 stefano Exp $
;

	XLIB	msx_vram
	
msx_vram:

	ld	a,(0FAFCh)		; mode
	and	00000110b		; extract VRAM size
	ld	hl,16			; assume 16K (MSX1)
	ret	z			; good assumption
	cp	00000010b		; 64K?
	ld	l,64			; assume so
	ret	z			; good assumption
	add	hl,hl			; 128K
	ret
