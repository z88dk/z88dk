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
;	$Id: f_ansi_dsr6.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;


	XLIB	ansi_DSR6

.ansi_DSR6
	; No TalkBack, at the moment
	ret


