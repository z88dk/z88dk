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
; $Id: ozserialout.asm,v 1.1 2003-10-22 09:56:34 stefano Exp $
;

	XLIB	ozserialout

ozserialout:
        ld      hl,2
        add     hl,sp
waittop:
        in      a,(45h)
        and     20h
        jr      z,waittop
        ld      a,(hl)
        out     (40h),a
        ret

