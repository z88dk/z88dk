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
; $Id: ozgetbaud.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozgetbaud
	PUBLIC	_ozgetbaud


ozgetbaud:
_ozgetbaud:
        in a,(43h)
        ld b,a
        or 80h
        out (43h),a
        in a,(40h)
        ld l,a
        in a,(41h)
        ld h,a
        ld a,b
        and 7fh
        out (43h),a
        ret
