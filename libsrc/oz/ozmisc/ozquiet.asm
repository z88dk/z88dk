;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozquiet()
;
; ------
; $Id: ozquiet.asm,v 1.1 2003-10-27 17:03:40 stefano Exp $
;

	XLIB	ozquiet

	LIB	ozclick

	XREF	ozclick_setting


ozquiet:
	xor	a
	out	(16h),a  ; turn off note
        ld      a,(ozclick_setting)
        or      a
        ret     z
        ld      hl,1
        push    hl
        call    ozclick
        pop     hl
	ret
