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
; $Id: ozdisplayactivepage.asm,v 1.1 2003-10-23 10:42:50 stefano Exp $
;

	XLIB	ozdisplayactivepage
	
	XREF	ozactivepage


ozdisplayactivepage:
        ld      a,(ozactivepage)
        out     (22h),a
;       ld      a,(ozactivepage+1)
;       out     (23h),a
        ret
