;
; 	ANSI Video handling for the Amstrad CPC
;
; 	Clean a text line
;
;	Stefano Bodrato - Jul. 2004
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.1 2004-07-15 10:03:49 stefano Exp $
;


	XLIB	ansi_del_line


.ansi_del_line

	ld	a,$11
	call	$BB5A
	ld	a,$12
	jp	$BB5A
