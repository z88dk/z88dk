;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozhour()
;
;
; ------
; $Id: ozhour.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozhour

	EXTERN	Compute	

ozhour:
        ld      c,35h
        jp      Compute
