;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	handles the click sound effect on keypress
;
; ------
; $Id: ozclick.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozclick
	PUBLIC	_ozclick
	PUBLIC	enable_click
	
	EXTERN	ozclick_setting


ozclick:
_ozclick:
        ld hl,2
        add hl,sp
        ld a,(hl)
        ld (ozclick_setting),a
        or      a
        ret     z


enable_click:
        ld      a,1
        out     (19h),a
        ld      a,10
        out     (17h),a
        xor     a
        out     (18h),a
        ld      a,2
        out     (16h),a         ;; enable key click
        ret

