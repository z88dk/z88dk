;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display contrast control functions
;
; ------
; $Id: ozgetcontrast.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozgetcontrast
	PUBLIC	_ozgetcontrast
	
	EXTERN	ozcontrast


ozgetcontrast:
_ozgetcontrast:
        ld      a,(ozcontrast)
        ld      l,a
        ld      h,0
        ret
