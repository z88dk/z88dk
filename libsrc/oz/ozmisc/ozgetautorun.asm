;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
; ------
; $Id: ozgetautorun.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozgetautorun
	

ozgetautorun:
        in      a,(4)
        push    af
        in      a,(3)
        push    af
        xor     a
        out     (3),a
        ld      c,4
        out     (c),c

        ld      a,(0bf2ch)
        ld      l,a
        ld      h,0

        pop     af
        out     (3),a
        pop     af
        out     (4),a
; ozsetautorun:		; unimplemented
        ret

