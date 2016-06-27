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
; $Id: ozsetlcr.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozsetlcr
	PUBLIC	_ozsetlcr


ozsetlcr:
_ozsetlcr:
        ld hl,2
        add hl,sp
        ld a,(hl)
        out (43h),a
        ret
