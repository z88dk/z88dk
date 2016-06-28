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
; $Id: ozgetdisplaypage.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozgetdisplaypage
	PUBLIC	_ozgetdisplaypage


ozgetdisplaypage:
_ozgetdisplaypage:
        in      a,(22h)
        or      a
        jr      z,PageZero
        ld      hl,1
        ret
PageZero:
        ld      l,a
        ld      h,a  ; hl=0
        ret
