;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
; 	CLS - Clear the screen
;
;
;	$Id: f_ansi_cls.asm,v 1.2 2015-01-19 01:33:19 pauloscustodio Exp $
;

	PUBLIC	ansi_cls

.ansi_cls
	ld		a,12
	jp  $60C0
