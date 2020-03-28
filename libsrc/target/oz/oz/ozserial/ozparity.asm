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
; $Id: ozparity.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozparity
	PUBLIC	_ozparity


ozparity:
_ozparity:
        ld hl,2
        add hl,sp
        in a,(43h)
        and 1+2+4+40h+80h
        or (hl)
        out (43h),a
        ret
