;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Invert HRG video output (hardware)
;
;	$Id: mt_invhrg.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

	SECTION code_clib
	PUBLIC	invhrg
	PUBLIC	_invhrg
	EXTERN	hrgmode

	; 2=true video, 3=inverse video

.invhrg
._invhrg
	ld	a,(hrgmode)
	xor	1
	ld	(hrgmode),a
	in	a,($5f)

	ret
