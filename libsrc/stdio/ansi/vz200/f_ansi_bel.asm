;
; 	ANSI Video handling for the VZ200
;
; 	BEL - chr(7)   Beep it out
;
;
;	Stefano Bodrato - Apr. 2000
;

	XLIB	ansi_BEL


.ansi_BEL
	call 13392
        ret

