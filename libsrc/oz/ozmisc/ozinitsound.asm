;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozinitsound(void)
;
; ------
; $Id: ozinitsound.asm,v 1.1 2003-10-27 17:03:40 stefano Exp $
;

	XLIB	ozinitsound


ozinitsound:
       ld      a,1
       out     (19h),a  ; turn tone mode on
       ret
