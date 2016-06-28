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
; $Id: ozsetcontrast.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozsetcontrast
	PUBLIC	_ozsetcontrast
	
	EXTERN	ozsetlcdstate

	EXTERN	ozcontrast
	EXTERN	s_ozlcdstatus


ozsetcontrast:
_ozsetcontrast:
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

