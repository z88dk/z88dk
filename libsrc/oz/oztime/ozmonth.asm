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
; $Id: ozmonth.asm,v 1.1 2003-10-21 17:15:22 stefano Exp $
;

	XDEF	ozmonth
	
	LIB	Compute	

ozmonth:
        ld      c,3ah
        jp      Compute
