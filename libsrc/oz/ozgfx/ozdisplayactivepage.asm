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
; $Id: ozdisplayactivepage.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozdisplayactivepage
	
	EXTERN	ozactivepage


ozdisplayactivepage:
        ld      a,(ozactivepage)
        out     (22h),a
;       ld      a,(ozactivepage+1)
;       out     (23h),a
        ret
