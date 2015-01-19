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
; $Id: ozgetlcr.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozgetlcr


ozgetlcr:
        in a,(43h)
        ld l,a
        ld h,0
        ret
