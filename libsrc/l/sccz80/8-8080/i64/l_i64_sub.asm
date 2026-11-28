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
EXTERN  l_sub_64_mde_mbc_mhl

l_i64_sub:
    ld      hl,2
    add     hl,sp
    ld      bc,hl
    ld      de,__i64_acc
    ld      hl,__i64_acc
    call    l_sub_64_mde_mbc_mhl    ;acc = operand - acc
    IF __CPU_GBZ80__
    pop     hl
    add     sp,8
    ELSE
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    ld      hl,de
    ENDIF
    jp      (hl)
