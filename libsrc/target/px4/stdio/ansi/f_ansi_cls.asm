;
; 	ANSI Video handling for the Epson PX4
;	By Stefano Bodrato - Nov 2014
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.2 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	clg

.ansi_cls
	jp	clg
