;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display blanking control functions
;	LCDStatus is 0c024h in the OS;
;
;
; ------
; $Id: ozunblankscreen.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozunblankscreen
	
	XDEF	s_blanked
	
	LIB	ozsetlcdstate

	XREF	s_ozlcdstatus


s_blanked:
        defb    0


; ozslow:
ozunblankscreen:
        ld      hl,s_blanked
        ld      a,(hl)
        or      a
        ret     z
        inc     a
        ld      (hl),a
        ld      a,5
        out     (24h),a
        ld      a,1
        out     (20h),a
        ld      hl,(s_ozlcdstatus)
        ld      a,l
        and     0bfh
        or      80h
        ld      l,a
        push    hl
        call    ozsetlcdstate
        pop     hl
        ret


