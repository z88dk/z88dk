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
; $Id: ozparity.asm,v 1.1 2003-10-22 09:56:34 stefano Exp $
;

	XLIB	ozparity


ozparity:
        ld hl,2
        add hl,sp
        in a,(43h)
        and 1+2+4+40h+80h
        or (hl)
        out (43h),a
        ret
