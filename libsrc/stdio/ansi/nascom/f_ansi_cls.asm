;
; 	ANSI Video handling for the NASCOM1/2
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Jul 2004
;
;
;	$Id: f_ansi_cls.asm,v 1.4 2015-01-19 01:33:18 pauloscustodio Exp $
;

	PUBLIC	ansi_cls
	EXTERN		cleargraphics

.ansi_cls
	jp cleargraphics

