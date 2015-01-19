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
; $Id: ozgetcontrast.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozgetcontrast
	
	EXTERN	ozcontrast


ozgetcontrast:
        ld      a,(ozcontrast)
        ld      l,a
        ld      h,0
        ret
