;
;       Small C+ Runtime Library
;
;       Random number generator
;
;       void srand(int) - seed "random" number
;
; -----
; $Id: srand.asm,v 1.2 2001-04-18 12:43:04 stefano Exp $

                XLIB    srand
                XREF    int_seed

.srand
        pop     bc
        pop     hl
        push    hl
        push    bc
        ld      (int_seed),hl
        ret

        