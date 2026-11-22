
    SECTION code_l_sccz80
    PUBLIC  l_i64_lneg
    EXTERN  __i64_acc

; Entry: hl = number to lneg
l_i64_lneg:
    ld    hl,__i64_acc
    ld    a,(hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    ld    hl,0
    ret   z
    inc   hl
    ret
