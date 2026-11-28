; sccz80 crt0 library - 8080 version
; 64-bit signed mod: __i64_acc = stacked operand mod% __i64_acc
;
; enter : stack = return address, dividend (8 bytes); __i64_acc = divisor
; exit  : __i64_acc = result, dividend removed from the stack

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_mod

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_i64_umod_8080
EXTERN  l_neg_64_mhl

l_i64_mod:
    ld      hl,sp+2
    ld      de,__i64_extra
    call    l_i64_cp8
    ld      a,(__i64_extra+7)
    ld      b,a
    ld      hl,__i64_acc+7
    xor     (hl)
    ld      c,a
    push    bc                      ;b = dividend sign, c = quotient sign
    ld      a,b
    rla
    jp      nc,l_i64_mod_x
    ld      hl,__i64_extra
    call    l_neg_64_mhl
l_i64_mod_x:
    ld      a,(__i64_acc+7)
    rla
    jp      nc,l_i64_mod_d
    ld      hl,__i64_acc
    call    l_neg_64_mhl
l_i64_mod_d:
    call    l_i64_umod_8080
    pop     bc
    ld      a,b
    rla
    jp      nc,l_i64_mod_done
    ld      hl,__i64_acc
    call    l_neg_64_mhl
l_i64_mod_done:
    pop     de
    ld      hl,sp+8
    ld      sp,hl
    ex      de,hl
    jp      (hl)
