; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; acc = acc & the stacked operand. The operand is removed.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_and

EXTERN  __i64_acc

l_i64_and:
    ld      hl,sp+2
    ld      de,__i64_acc
    ld      b,8
l_i64_and_loop:
    ld      a,(de)
    and     a,(hl+)
    ld      (de+),a
    dec     b
    jr      nz,l_i64_and_loop
    pop     hl
    add     sp,8
    jp      (hl)
