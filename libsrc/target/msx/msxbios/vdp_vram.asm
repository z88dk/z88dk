;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int vdp_vram();
;
;	Detects the VRAM size (in KB)
;
;	$Id: vdp_vram.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_vram
	PUBLIC	_vdp_vram
	
vdp_vram:
_vdp_vram:

	ld	a,(0FAFCh)		; mode
	and	@00000110		; extract VRAM size
	ld	hl,16			; assume 16K (MSX1)
	ret	z			; good assumption
	cp	@00000010		; 64K?
	ld	l,64			; assume so
	ret	z			; good assumption
	add	hl,hl			; 128K
	ret
