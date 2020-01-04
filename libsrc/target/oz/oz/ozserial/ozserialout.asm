;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	Serial libraries
;
;
; ------
; $Id: ozserialout.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozserialout
	PUBLIC	_ozserialout

ozserialout:
_ozserialout:
        ld      hl,2
        add     hl,sp
waittop:
        in      a,(45h)
        and     20h
        jr      z,waittop
        ld      a,(hl)
        out     (40h),a
        ret

