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
; $Id: ozinitsound.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozinitsound
	PUBLIC	_ozinitsound


ozinitsound:
_ozinitsound:
       ld      a,1
       out     (19h),a  ; turn tone mode on
       ret
