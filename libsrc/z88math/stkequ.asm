;
;	Z88dk Z88 Maths Library
;
;
;	$Id: stkequ.asm,v 1.1 2002-01-21 20:36:07 dom Exp $

		XLIB	stkequ

		XREF	fa

;Equalise the stack, and put the calculated value into FA

.stkequ
        ld      (fa+3),hl
        ld      a,c
        ld      (fa+5),a
        exx
        ld      (fa+1),hl
;        xor     a
;        ld      (fa),a
        pop     hl      ;ret to program
        pop     bc      ;get rid of fp number
        pop     bc
        pop     bc
        jp      (hl)    ;outa here back to program

