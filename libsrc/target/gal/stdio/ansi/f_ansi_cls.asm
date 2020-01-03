;
; 	ANSI Video handling for the Galaksija
;	By Stefano Bodrato - 2017
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm $
;

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	filltxt

.ansi_cls

	ld	l,32
	jp	filltxt
