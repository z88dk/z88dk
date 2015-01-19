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
; $Id: ozinitsound.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozinitsound


ozinitsound:
       ld      a,1
       out     (19h),a  ; turn tone mode on
       ret
