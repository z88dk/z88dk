;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozkeyboardoff()
;
; ------
; $Id: ozkbdoff.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozkbdoff
	PUBLIC	_ozkbdoff


ozkbdoff:
_ozkbdoff:
        in      a,(7)
        or      1
        out     (7),a
        ret
