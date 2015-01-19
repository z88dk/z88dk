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
;	$Id: f_ansi_dsr6.asm,v 1.3 2015-01-19 01:33:18 pauloscustodio Exp $
;


	PUBLIC	ansi_DSR6

.ansi_DSR6
	; No TalkBack, at the moment
	ret


