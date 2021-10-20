;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_long_asr
PUBLIC    l_long_asro

; Entry:    dehl = long
;        c = shift couter
.l_long_asro
    ld      a,c
    jp      entry

; Entry:    l = counter
;        sp + 2 = long to shift

.l_long_asr
    pop     bc
    ld      a,l     ;temporary store for counter
    pop     hl
    pop     de
    push    bc

.entry
    and     31
    ret     Z

    ld      b,a

.loop
    ld      a,d
    rla
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a

    dec     b
    jp      NZ,loop
    ret
