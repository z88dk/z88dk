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
	
	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN
	EXTERN	text_rows

	EXTERN	ansi_SCROLLUP

.ansi_LF
 xor a          ; yes,
 ld (ansi_COLUMN),a       ; automatic CR
 ld a,(ansi_ROW)
 inc a
 ld (ansi_ROW),a
 ld hl,text_rows
 cp (hl)	; Out of screen?
 ret nz		; no, return
 ld a,(text_rows)
 dec a		; yes!
 ld (ansi_ROW),a
 jp ansi_SCROLLUP
