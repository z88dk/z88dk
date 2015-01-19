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
; $Id: ozkbdon.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;


	PUBLIC	ozkbdon


ozkbdon:
        in      a,(7)
        and     0feh
        out     (7),a
        ret
