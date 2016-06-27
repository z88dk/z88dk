;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozkeyboardon()
;
; ------
; $Id: ozkbdon.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozkbdon
	PUBLIC	_ozkbdon


ozkbdon:
_ozkbdon:
        in      a,(7)
        and     0feh
        out     (7),a
        ret
