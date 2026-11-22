;
;       Z80 ANSI Library
;
;---------------------------------------------------
; 	LF - chr(10)	Line Feed
;	Do also a Carriage return.
;
;	Stefano Bodrato - 21/4/2000
;
;	$Id: f_ansi_lf.asm,v 1.4 2016-04-04 18:31:22 dom Exp $
;

	SECTION code_clib
	PUBLIC	ansi_LF
	
	EXTERN	__console_y
	EXTERN	__console_x
	EXTERN	__console_h

	EXTERN	ansi_SCROLLUP

.ansi_LF
 xor a          ; yes,
 ld (__console_x),a       ; automatic CR
 ld a,(__console_y)
 inc a
 ld (__console_y),a
 ld hl,__console_h
 cp (hl)	; Out of screen?
 ret nz		; no, return
 ld a,(__console_h)
 dec a		; yes!
 ld (__console_y),a
 jp ansi_SCROLLUP
