
    SECTION code_l_sccz80
    PUBLIC  l_i64_and
    EXTERN  __i64_acc

; Entry: acc = LHS
;        sp+2 = RHS
; Exit:  acc = LHS & RHS
l_i64_and:
    ld      hl,2
    add     hl,sp
    ld      de,__i64_acc
    ld      b,8
loop:
    ld      a,(de)
    and     (hl)
    ld      (de),a
    inc     hl
    inc     de
    djnz    loop
    pop     de
    ld      sp,hl
    ex      de,hl
    jp      (hl)
