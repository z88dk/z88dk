;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Invert HRG video output (hardware)
;
;	$Id: mt_invhrg.asm,v 1.2 2015-01-19 01:32:52 pauloscustodio Exp $
;

	PUBLIC	invhrg
	EXTERN	hrgmode

	; 2=true video, 3=inverse video

.invhrg
	ld	a,(hrgmode)
	xor	1
	ld	(hrgmode),a
	in	a,($5f)

	ret
