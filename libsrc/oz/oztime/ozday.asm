;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozday()
;
;
; ------
; $Id: ozday.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozday
	PUBLIC	_ozday
	
	EXTERN	Compute	

ozday:
_ozday:
        ld      c,38h
        jp      Compute
