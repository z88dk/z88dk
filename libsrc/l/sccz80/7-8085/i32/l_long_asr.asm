;       Z88 Small C+ Run Time Library
;       Long functions
;
;       feilipu 10/2021
;       8085 optimisation

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_long_asr
PUBLIC  l_long_asro

; Entry:    dehl = long
;           c = shift counter
.l_long_asro
    ld      a,c
    jp      entry

; Entry:    l = counter
;        sp + 2 = long to shift

.l_long_asr
    pop     bc
    ld      a,l
    pop     hl
    pop     de
    push    bc

.entry
    and     31
    ret     Z

    ld      b,a
    ex      de,hl

.loop
    sra     hl

    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a

    dec     b
    jp      NZ,loop
    ex      de,hl
    ret
