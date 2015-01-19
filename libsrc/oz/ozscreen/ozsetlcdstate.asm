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
;	ozsetlcdstate - service routine
;
;
; ------
; $Id: ozsetlcdstate.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozsetlcdstate
	
	EXTERN	s_ozlcdstatus

	EXTERN	restore_a000

ozsetlcdstate:
        pop     de
        pop     hl        ;; status to set
        push    hl
        push    de

        xor     a
        out     (3),a
        ld      a,3
        out     (4),a      ;; page in page 300h
        ld      (0a000h),hl
        ld      (s_ozlcdstatus),hl
        jp      restore_a000

