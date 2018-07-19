;
; 	ANSI Video handling for the PC6001
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN  generic_console_cls

	defc	ansi_cls = generic_console_cls

