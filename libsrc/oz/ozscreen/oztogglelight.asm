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
; $Id: oztogglelight.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	oztogglelight
	PUBLIC	_oztogglelight
	
	EXTERN	ozbacklight
	
	EXTERN	ozsetlight


oztogglelight:
_oztogglelight:
        ld      a,(ozbacklight)
        and     040h
        xor     040h
        ld      l,a
        push    hl
        call    ozsetlight
        pop     hl
        ret

