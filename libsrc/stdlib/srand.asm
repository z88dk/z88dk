;
;       Small C+ Runtime Library
;
;       Random number generator
;
;       void srand(int) - seed "random" number
;
;
                XLIB    srand
                XREF    int_seed

.srand
        pop     bc
        pop     hl
        push    hl
        push    bc
        ld      (int_seed),hl
        ret

        