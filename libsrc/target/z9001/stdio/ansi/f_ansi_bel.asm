;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;
; 	BEL - chr(7)   Beep it out
;
;
;
;	$Id: f_ansi_bel.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_BEL


.ansi_BEL
	ld  c,7
	jp  $f00c		; conout

