;
; 	ANSI Video handling for the Visual 1050
;
;	Stefano Bodrato - 2023
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm $
;

        SECTION  code_clib

        PUBLIC	 ansi_SCROLLUP
        EXTERN   generic_console_scrollup


ansi_SCROLLUP:
		jp generic_console_scrollup
