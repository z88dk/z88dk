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
; $Id: ozgetlcr.asm,v 1.1 2003-10-22 09:56:34 stefano Exp $
;

	XLIB	ozgetlcr


ozgetlcr:
        in a,(43h)
        ld l,a
        ld h,0
        ret
