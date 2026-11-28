; Logical negation of __i64_acc
;
; exit  : hl = 1 and carry set if the value is zero, else hl = 0 and
;         carry clear (the same as l_long_lneg)

    SECTION code_l_sccz80
    PUBLIC  l_i64_lneg
    EXTERN  __i64_acc
    EXTERN  error_lznc
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
    jp    nz,error_lznc
    ld    hl,1
    scf
    ret
