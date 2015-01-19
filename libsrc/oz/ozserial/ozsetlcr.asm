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
; $Id: ozsetlcr.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozsetlcr


ozsetlcr:
        ld hl,2
        add hl,sp
        ld a,(hl)
        out (43h),a
        ret
