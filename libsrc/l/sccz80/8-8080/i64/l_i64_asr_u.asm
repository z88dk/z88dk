; sccz80 crt0 library - 8080 version
; 64-bit shift of the stacked operand by a bits, result in __i64_acc
;
; enter : a = shift count (l_i64_asr_uo) or count in (__i64_acc) (l_i64_asr_u)
;         stack = return address, operand (8 bytes)
; exit  : __i64_acc = result, operand removed from the stack

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_asr_u
PUBLIC  l_i64_asr_uo

EXTERN  __i64_acc
EXTERN  l_i64_cp8

l_i64_asr_u:
    ld      a,(__i64_acc+0)
l_i64_asr_uo:
    push    af
    ld      hl,4
    add     hl,sp
    ld      de,__i64_acc
    call    l_i64_cp8
    pop     af
    ld      c,a
    and     a
    jp      z,l_i64_asr_u_done
l_i64_asr_u_loop:
    ld      hl,__i64_acc+7
    ld      b,8
    and     a
l_i64_asr_u_1:
    ld      a,(hl)
    rra
    ld      (hl-),a
    dec     b
    jp      nz,l_i64_asr_u_1
    dec     c
    jp      nz,l_i64_asr_u_loop
l_i64_asr_u_done:
    pop     de
    ld      hl,8
    add     hl,sp
    ld      sp,hl
    ex      de,hl
    jp      (hl)
