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
; $Id: ozkbdon.asm,v 1.1 2003-10-22 13:55:49 stefano Exp $
;


	XLIB	ozkbdon


ozkbdon:
        in      a,(7)
        and     0feh
        out     (7),a
        ret
