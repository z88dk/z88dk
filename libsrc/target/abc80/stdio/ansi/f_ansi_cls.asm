;
; 	ANSI Video handling for the ABC80
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - May 2000
;
;
;	$Id: f_ansi_cls.asm,v 1.5 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
	jp	$276
