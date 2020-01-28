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
; $Id: ozweekday.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozweekday
	PUBLIC	_ozweekday
	

ozweekday:
_ozweekday:
        in      a,(36h)
        and     0fh
        ld      l,a
        ld      h,0
        ret
