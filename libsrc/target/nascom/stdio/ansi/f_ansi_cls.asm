;
; 	ANSI Video handling for the NASCOM1/2
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Jul 2004
;
;
;	$Id: f_ansi_cls.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_cls
	EXTERN		cleargraphics

.ansi_cls
	jp cleargraphics

