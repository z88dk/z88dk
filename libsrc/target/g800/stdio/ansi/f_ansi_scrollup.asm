;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP


.ansi_SCROLLUP
	call $Be53
	jr nc,ansi_SCROLLUP
	jp $bfeb
