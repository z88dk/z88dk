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
; $Id: oztogglelight.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	oztogglelight
	
	EXTERN	ozbacklight
	
	EXTERN	ozsetlight


oztogglelight:
        ld      a,(ozbacklight)
        and     040h
        xor     040h
        ld      l,a
        push    hl
        call    ozsetlight
        pop     hl
        ret

