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
; $Id: ozclick.asm,v 1.1 2003-10-21 17:15:20 stefano Exp $
;


	XLIB	ozclick
	XDEF	enable_click
	
	XREF	ozclick_setting


ozclick:
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

