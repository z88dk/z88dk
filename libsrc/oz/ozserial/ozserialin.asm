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
; $Id: ozserialin.asm,v 1.1 2003-10-22 09:56:34 stefano Exp $
;

	XLIB	ozserialin

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
