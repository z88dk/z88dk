;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozmonth()
;
;
; ------
; $Id: ozmonth.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozmonth
	
	EXTERN	Compute	

ozmonth:
        ld      c,3ah
        jp      Compute
