;
; 	ANSI Video handling for the P2000T
;
;	Stefano Bodrato - Apr. 2014
;
;
; 	CLS - Clear the screen
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
	ld		a,12
	jp  $60C0
