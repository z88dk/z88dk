;
; 	ANSI Video handling for the Sharp MZ
;	By Stefano Bodrato - 5/5/2000
;
; 	BEL - chr(7)   Beep it out
;

	XLIB	ansi_BEL


.ansi_BEL
	jp	$3E	; Beep !
