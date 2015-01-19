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
; $Id: ozserialin.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozserialin

ozserialin:
        in      a,(45h)
        and     1
        jr      z,nothing
        in      a,(40h)
        ld      l,a
        ld      h,0
        ret
nothing:
        ld      hl,-1
        ret
