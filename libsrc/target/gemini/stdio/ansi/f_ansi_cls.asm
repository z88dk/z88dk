;
; 	ANSI Video handling for the Gemini Galaxy
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - 2022
;
;
;	$Id: f_ansi_cls.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_cls
	EXTERN	generic_console_cls

	defc	ansi_cls = generic_console_cls
