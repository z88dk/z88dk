; sccz80 crt0 library - 8080 version
; __i64_acc = the stacked operand - __i64_acc
;
; enter : stack = return address, operand (8 bytes)
; exit  : __i64_acc = difference, operand removed from the stack
; uses  : af, bc, de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_sub

EXTERN  __i64_acc
EXTERN  l_i64_cp8
EXTERN  l_sub_64_mde_mhl

l_i64_sub:
    ld      hl,2
    add     hl,sp
    ex      de,hl
    ld      hl,__i64_acc
    call    l_sub_64_mde_mhl        ;operand = operand - acc, in place
    ld      hl,2
    add     hl,sp
    ld      de,__i64_acc
    call    l_i64_cp8
    pop     de
    ld      sp,hl
    ex      de,hl
    jp      (hl)
