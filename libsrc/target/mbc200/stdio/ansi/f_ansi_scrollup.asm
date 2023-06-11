;
; 	ANSI Video handling for the Sanyo computers
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

        EXTERN    generic_console_scrollup

ansi_SCROLLUP:
		jp generic_console_scrollup
