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
; $Id: ozgetcontrast.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozgetcontrast
	
	XREF	ozcontrast


ozgetcontrast:
        ld      a,(ozcontrast)
        ld      l,a
        ld      h,0
        ret
