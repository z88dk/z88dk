; sccz80 crt0 library - 8080 version
; 64-bit unsigned div: __i64_acc = stacked operand /div __i64_acc
;
; enter : stack = return address, dividend (8 bytes); __i64_acc = divisor
; exit  : __i64_acc = result, dividend removed from the stack

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_div_u

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_i64_load
EXTERN  l_i64_udiv_8080


l_i64_div_u:
    ld      hl,sp+2
    ld      de,__i64_extra
    call    l_i64_cp8

    call    l_i64_udiv_8080
    ld      hl,__i64_extra
    call    l_i64_load
l_i64_div_u_done:
    pop     de
    ld      hl,sp+8
    ld      sp,hl
    ex      de,hl
    jp      (hl)
