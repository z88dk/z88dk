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
; $Id: ozquiet.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozquiet

	EXTERN	ozclick

	EXTERN	ozclick_setting


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
