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
;	$Id: f_ansi_bel.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_BEL
	EXTERN	montest

	; This could put a symbol somewhere on the screen, as a side effect.

.ansi_BEL
	call	montest
	jr	nz,nassys
	
; T monitor
	ld	a,7
	jp	0c4ah

.nassys
; NASSYS monitor
	ld	a,7
	defb	0f7h
	ret

