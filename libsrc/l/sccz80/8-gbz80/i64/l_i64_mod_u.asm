; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; 64-bit unsigned mod: __i64_acc = stacked operand mod% __i64_acc
;
; enter : stack = return address, dividend (8 bytes); __i64_acc = divisor
; exit  : __i64_acc = result, dividend removed from the stack

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_mod_u

EXTERN  __i64_acc
EXTERN  __i64_extra
EXTERN  l_i64_cp8
EXTERN  l_i64_umod_8080


l_i64_mod_u:
    ld      hl,sp+2
    ld      de,__i64_extra
    call    l_i64_cp8

    call    l_i64_umod_8080

l_i64_mod_u_done:
    pop     hl
    add     sp,8
    jp      (hl)
