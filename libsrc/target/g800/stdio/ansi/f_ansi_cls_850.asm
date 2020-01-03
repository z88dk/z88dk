;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;
; 	CLS - Clear the screen
;	
;	$Id: f_ansi_cls_850.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_cls
	
	EXTERN init_screen

.ansi_cls

	jp init_screen
