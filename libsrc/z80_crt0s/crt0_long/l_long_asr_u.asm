;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 22/3/99 Unsigned version

                XLIB    l_long_asr_u



; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asr_u
        ld      a,l     ;temporary store for counter
        pop     bc      ;return address
        pop     hl
        pop     de
        push    bc
        ld      c,a
.l_long_asr_u1
        dec     c
        ret     m       ;counter has flipped to 255
        and     a
        rr      d
        rr      e
        rr      h
        rr      l
        jr      l_long_asr_u1



IF ARCHAIC

.l_long_asr
        exx
        pop     bc
        pop     hl
        pop     de
        push    bc
.l_long_asr1
        exx     ;1st
        dec     l
        exx     ;2nd
        ret     m       ;dehl' was zero..
        ld      a,d
        rla
        rr      d
        rr      e
        rr      h
        rr      l
        jr      l_long_asr1
ENDIF
