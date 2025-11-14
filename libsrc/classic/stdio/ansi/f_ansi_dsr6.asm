;
;       Z80 ANSI Library
;
;---------------------------------------------------
; 	Device status report - 6
;	Give the cursor position:
;	Should reply with {ESC}[x;yR
;
;	Stefano Bodrato - Apr. 2000
;
;	$Id: f_ansi_dsr6.asm,v 1.4 2016-04-04 18:31:22 dom Exp $
;
	SECTION  code_clib

	PUBLIC	ansi_DSR6

.ansi_DSR6
	; No TalkBack, at the moment
	ret


