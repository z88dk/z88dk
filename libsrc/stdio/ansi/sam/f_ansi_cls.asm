;
;       SAM Coupé C Library
;
; 	ANSI Video handling for SAM Coupé
;
; 	CLS - Clear the screen
;	
;
;	Frode Tennebø - 29/12/2002
;
;
;	$Id: f_ansi_cls.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls

.ansi_cls
 	xor	a
	jp	$014E
