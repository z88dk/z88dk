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
; $Id: ozdatabits.asm,v 1.1 2003-10-22 09:56:34 stefano Exp $
;

	XLIB	ozdatabits


ozdatabits:
        ld      hl,2
        add     hl,sp
        in      a,(43h)
        and     0FFh-3
        or      (hl)
        out     (43h),a
        ret
