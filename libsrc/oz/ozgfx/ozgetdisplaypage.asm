;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	Videmo memory page handling
;
;
; ------
; $Id: ozgetdisplaypage.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozgetdisplaypage


ozgetdisplaypage:
        in      a,(22h)
        or      a
        jr      z,PageZero
        ld      hl,1
        ret
PageZero:
        ld      l,a
        ld      h,a  ; hl=0
        ret
