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
; $Id: ozhour.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozhour
	PUBLIC	_ozhour

	EXTERN	Compute	

ozhour:
_ozhour:
        ld      c,35h
        jp      Compute
