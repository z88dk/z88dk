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


	XLIB	ansi_DSR6

.ansi_DSR6
	; No TalkBack, at the moment
	ret


