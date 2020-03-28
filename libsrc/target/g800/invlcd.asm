;
;       G850 library
;
;--------------------------------------------------------------
;
;       $Id: invlcd.asm $
;
;----------------------------------------------------------------
;
; invlcd(1) - invert display
; invlcd(0) - restore display
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    invlcd
        PUBLIC    _invlcd

invlcd:
_invlcd:
		ld	a,166
		add	l
		out	(64),a
		ret
