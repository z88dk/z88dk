;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozmin()
;
;
; ------
; $Id: ozmin.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozmin
	
	EXTERN	Compute	

ozmin:
        ld      c,33h
        jp      Compute
