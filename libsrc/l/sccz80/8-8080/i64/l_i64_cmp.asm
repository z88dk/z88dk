; sccz80 crt0 library - 8080 version
; Signed 64-bit compare of the stacked operand with __i64_acc
;
; enter : stack = return address, operand (8 bytes); __i64_acc = right side
; exit  : operand removed from the stack, hl = 1
;         carry set if operand < __i64_acc, z set if equal
;
; The sign of the difference is wrong when the subtraction overflows, so
; operands of unlike sign are decided by the sign of the operand alone.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_cmp

EXTERN  l_sub_64_mde_mhl
EXTERN  __i64_acc

l_i64_cmp:
    ld      hl,4+7
    add     hl,sp
    ld      c,(hl)                  ;sign byte of the operand
    ld      a,(__i64_acc+7)
    xor     c
    ld      b,a                     ;bit 7 set if the signs differ
    ld      hl,4
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    call    l_sub_64_mde_mhl        ;operand = operand - __i64_acc
    ld      hl,4+7
    add     hl,sp
    ld      a,b
    and     a
    ld      a,(hl)
    jp      p,l_i64_cmp_1
    ld      a,c                     ;unlike signs: less if the operand is negative
l_i64_cmp_1:
    and     a
    jp      p,l_i64_cmp_pos
    pop     bc
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    push    de
    push    bc
    ld      hl,1
    scf
    ret
l_i64_cmp_pos:
    ld      b,7
    ld      a,(hl)
l_i64_cmp_2:
    dec     hl
    or      (hl)
    dec     b
    jp      nz,l_i64_cmp_2
    pop     bc
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    push    de
    push    bc
    and     a                       ;equality in z, carry clear
    ld      hl,1
    ret
