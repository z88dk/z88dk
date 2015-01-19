;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozweekday()
;
;
; ------
; $Id: ozweekday.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozweekday
	

ozweekday:
        in      a,(36h)
        and     0fh
        ld      l,a
        ld      h,0
        ret
