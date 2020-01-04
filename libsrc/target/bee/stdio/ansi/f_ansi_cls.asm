;
; 	ANSI Video handling for the MicroBEE
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - 2016
;
;
;	$Id: f_ansi_cls.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_cls
	EXTERN	generic_console_cls

	defc	ansi_cls = generic_console_cls
