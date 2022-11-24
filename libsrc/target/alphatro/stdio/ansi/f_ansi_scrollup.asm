;
; 	ANSI Video handling for the the Alphatronic
;
;	Stefano Bodrato - 2022
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	generic_console_scrollup

	defc	ansi_SCROLLUP = generic_console_scrollup
