;
; 	ANSI Video handling for the the MicroBEE
;
;	Stefano Bodrato - 2016
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	generic_console_scrollup

	defc	ansi_SCROLLUP = generic_console_scrollup
