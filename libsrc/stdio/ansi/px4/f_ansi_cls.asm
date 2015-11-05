;
; 	ANSI Video handling for the Epson PX4
;	By Stefano Bodrato - Nov 2014
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.1 2015-11-05 16:08:04 stefano Exp $
;

	PUBLIC	ansi_cls
	EXTERN	clg

.ansi_cls
	jp	clg
