;       Z88 Small C+ Run Time Library
;       Long functions
;       "8080" mode
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_long_asr_u
PUBLIC    l_long_asr_uo

; Entry: dehl = long
;           c = shift
.l_long_asr_uo
    ld      a,c
    jp      entry


; Shift primary (on stack) right by secondary,
.l_long_asr_u
    pop     bc
    ld      a,l     ;temporary store for counter
    pop     hl
    pop     de
    push    bc

.entry 
    and     31
    ret     Z

    ld      b,a
    ld      a,e     ;Primary = dahl

.loop
    srl     d
    rra
    rr      h
    rr      l
    dec     b
    jp      NZ,loop

    ld      e,a
    ret
