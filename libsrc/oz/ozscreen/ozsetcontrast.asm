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
; $Id: ozsetcontrast.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozsetcontrast
	
	EXTERN	ozsetlcdstate

	EXTERN	ozcontrast
	EXTERN	s_ozlcdstatus


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

