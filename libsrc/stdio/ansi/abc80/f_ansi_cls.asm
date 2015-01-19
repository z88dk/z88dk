;
; 	ANSI Video handling for the ABC80
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - May 2000
;
;
;	$Id: f_ansi_cls.asm,v 1.4 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_cls

.ansi_cls
	jp	$276
