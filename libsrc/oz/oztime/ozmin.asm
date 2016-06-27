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
; $Id: ozmin.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozmin
	PUBLIC	_ozmin
	
	EXTERN	Compute	

ozmin:
_ozmin:
        ld      c,33h
        jp      Compute
