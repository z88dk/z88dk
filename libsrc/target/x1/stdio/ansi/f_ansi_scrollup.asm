;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.6 2016-07-20 05:45:02 stefano Exp $
;

    SECTION code_clib
    PUBLIC  ansi_SCROLLUP

    EXTERN  generic_console_scrollup

    defc    ansi_SCROLLUP = generic_console_scrollup
    