;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Invert HRG video output (hardware)
;
;	$Id: mt_invhrg.asm,v 1.1 2010-02-10 16:15:35 stefano Exp $
;

	XLIB	invhrg
	XREF	hrgmode

	; 2=true video, 3=inverse video

.invhrg
	ld	a,(hrgmode)
	xor	1
	ld	(hrgmode),a
	in	a,($5f)

	ret
