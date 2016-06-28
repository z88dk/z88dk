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
; $Id: ozquiet.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozquiet
	PUBLIC	_ozquiet

	EXTERN	ozclick

	EXTERN	ozclick_setting


ozquiet:
_ozquiet:
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
