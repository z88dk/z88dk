;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display backlight control functions
;
;
;	void oztogglelight(void)
;
;
;
; ------
; $Id: oztogglelight.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	oztogglelight
	
	XREF	ozbacklight
	
	LIB	ozsetlight


oztogglelight:
        ld      a,(ozbacklight)
        and     040h
        xor     040h
        ld      l,a
        push    hl
        call    ozsetlight
        pop     hl
        ret

