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
; $Id: ozdisplayactivepage.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozdisplayactivepage
	PUBLIC	_ozdisplayactivepage
	
	EXTERN	ozactivepage


ozdisplayactivepage:
_ozdisplayactivepage:
        ld      a,(ozactivepage)
        out     (22h),a
;       ld      a,(ozactivepage+1)
;       out     (23h),a
        ret
