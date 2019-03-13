;
; 	ANSI Video handling for the Epson PX8
;	By Stefano Bodrato - 2019
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm $
;

	SECTION code_clib
	PUBLIC	ansi_cls
	
	EXTERN	clg

.ansi_cls
	jp	clg
