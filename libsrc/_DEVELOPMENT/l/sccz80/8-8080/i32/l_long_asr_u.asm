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
    ld a,c
    jp entry


; Shift primary (on stack) right by secondary,
.l_long_asr_u
    pop    bc
    ld      a,l     ;temporary store for counter
    pop     hl
    pop     de
    push    bc

.entry 
    and    31
    ret    z

    ld    b,a
IF __CPU_GBZ80__
    ld    a,e    ;Primary = dahl
ENDIF

.loop
IF __CPU_GBZ80__
    srl    d
    rra
    rr    h
    rr    l
ELSE
    and    a
    ld    a,d
    rra
    ld    d,a
    ld    a,e
    rra
    ld    e,a
    ld    a,h
    rra
    ld    h,a
    ld    a,l
    rra
    ld    l,a
ENDIF

    dec    b
    jp    nz,loop
IF __CPU_GBZ80__
    ld    e,a
ENDIF

    ret
