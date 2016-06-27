;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	Serial libraries
;	serial control commands
;
; ------
; $Id: ozgetlcr.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozgetlcr
	PUBLIC	_ozgetlcr


ozgetlcr:
_ozgetlcr:
        in a,(43h)
        ld l,a
        ld h,0
        ret
