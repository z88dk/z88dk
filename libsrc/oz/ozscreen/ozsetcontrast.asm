;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display contrast control functions
;
; ------
; $Id: ozsetcontrast.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozsetcontrast
	
	LIB	ozsetlcdstate

	XREF	ozcontrast
	XREF	s_ozlcdstatus


ozsetcontrast:
        pop     hl
        pop     bc
        push    bc
        push    hl
        ld      a,c
        cp      40h
        jr      c,LeaveAlone
        ld      a,3fh
LeaveAlone:
        ld      (ozcontrast),a
        ld      e,a
        ld      bc,(s_ozlcdstatus)
        ld      a,c
        and     0ffh-3fh
        or      e
        ld      c,a
        push    bc
        call    ozsetlcdstate
        pop     bc
        ret

