; sccz80 crt0 library - 8085 version
; Unsigned 64-bit compare of the stacked operand with __i64_acc
;
; enter : stack = return to the wrapper, return to the caller, operand
;         __i64_acc = right side
; exit  : operand removed, both returns restored, __i64_acc unchanged
;         hl = 1
;         carry set if operand < __i64_acc, z set if equal
;         S, P, V and A are not part of the result

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_ucmp

EXTERN  __i64_acc

l_i64_ucmp:
    ld      hl,(__i64_acc+6)
    ld      bc,hl
    ld      de,sp+10
    ld      hl,(de)
    sub     hl,bc
    jp      c,l_i64_ucmp_less

    jp      nz,l_i64_ucmp_greater

    ld      hl,(__i64_acc+4)
    ld      bc,hl
    ld      de,sp+8
    ld      hl,(de)
    sub     hl,bc
    jp      c,l_i64_ucmp_less

    jp      nz,l_i64_ucmp_greater

    ld      hl,(__i64_acc+2)
    ld      bc,hl
    ld      de,sp+6
    ld      hl,(de)
    sub     hl,bc
    jp      c,l_i64_ucmp_less

    jp      nz,l_i64_ucmp_greater

    ld      hl,(__i64_acc+0)
    ld      bc,hl
    ld      de,sp+4
    ld      hl,(de)
    sub     hl,bc
    jp      c,l_i64_ucmp_less

    jp      nz,l_i64_ucmp_greater

l_i64_ucmp_equal:
    pop     bc
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    push    de
    push    bc
    xor     a
    ld      hl,1
    ret

l_i64_ucmp_less:
    pop     bc
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    push    de
    push    bc
    or      1
    scf
    ld      hl,1
    ret

l_i64_ucmp_greater:
    pop     bc
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    push    de
    push    bc
    or      1
    ld      hl,1
    ret
