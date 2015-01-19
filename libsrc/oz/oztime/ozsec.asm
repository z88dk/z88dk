;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozsec()
;
;
; ------
; $Id: ozsec.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozsec
	
	EXTERN	Compute	

ozsec:
        ld      c,31h
        jp      Compute
