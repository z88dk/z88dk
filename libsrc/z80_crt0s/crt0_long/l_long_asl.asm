;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)


                XLIB    l_long_asl


; Shift primary left by secondary
;
; Primary is on the stack, and is 32 bits long therefore we need only
; concern ourselves with l (secondary) as our counter


.l_long_asl
        ld      a,l     ;counter
        pop     bc
        pop     hl
        pop     de
        push    bc
.l_long_asl1
        dec     a
        ret     m       ;flipped down to 255
        add     hl,hl   ;double lower 16
        ex      de,hl
        adc     hl,hl   ;double upper 16 (taking into a/c carry from prev)
        ex      de,hl
        jr      l_long_asl1


IF ARCHAIC

;shift left as for l_long_asr

.l_long_asl
        exx
        pop     bc
        pop     hl
        pop     de
        push    bc
.l_long_asl1
        exx
        dec     l
        exx
        ret     m
        add     hl,hl
        ex      de,hl
        adc     hl,de
        ex      de,hl
        jr      l_long_asl1


ENDIF