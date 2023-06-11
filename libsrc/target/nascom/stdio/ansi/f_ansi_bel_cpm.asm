;
; 	ANSI Video handling for the NASCOM1/2
;
; 	BEL - chr(7)   Beep it out
;
;	Stefano Bodrato - Jul 2004
;
;	No sound on nascom (?).  We'll look for some trick..
;	What about making buzz the tape relais ?
;
;	$Id: f_ansi_bel_cpm.asm $
;

	SECTION	code_clib
	PUBLIC	ansi_BEL

	EXTERN	__bdos

	; This could put a symbol somewhere on the screen, as a side effect.

.ansi_BEL

	ld	a,7
	ld      c,2
	jp	__bdos

