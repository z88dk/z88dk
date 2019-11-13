;
; 	ANSI Video handling for the Sharp X1
;	Karl Von Dyson (for X1s.org) - 24/10/2013
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.6 2016-07-20 05:45:02 stefano Exp $
;

    SECTION code_clib
    PUBLIC	ansi_cls
    EXTERN  generic_console_cls

    defc    ansi_cls = generic_console_cls
