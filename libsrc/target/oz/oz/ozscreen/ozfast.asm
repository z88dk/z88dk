;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display blanking control functions
;	LCDStatus is 0c024h in the OS;
;
;	ozslow is same than ozunblankscreen
;
;
; ------
; $Id: ozfast.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozfast
	PUBLIC	_ozfast
	
	EXTERN	ozblankscreen
	
ozfast:
_ozfast:
        call    ozblankscreen
        xor     a
        out     (20h),a
        out     (24h),a
        ret
