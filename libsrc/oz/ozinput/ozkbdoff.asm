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
; $Id: ozkbdoff.asm,v 1.1 2003-10-22 13:55:49 stefano Exp $
;


	XLIB	ozkbdoff


ozkbdoff:
        in      a,(7)
        or      1
        out     (7),a
        ret
