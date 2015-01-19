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
; $Id: ozstopbits.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozstopbits


ozstopbits:
        ld hl,2
        add hl,sp
        in a,(43h)
        and 1+2+8+10h+20h+40h+80
        or (hl)
        out (43h),a
        ret
