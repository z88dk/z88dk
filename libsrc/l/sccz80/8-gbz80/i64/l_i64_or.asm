; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; acc = acc | the stacked operand. The operand is removed.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_or

EXTERN  __i64_acc

l_i64_or:
    ld      hl,sp+2
    ld      de,__i64_acc
    ld      b,8
l_i64_or_loop:
    ld      a,(de)
    or      a,(hl+)
    ld      (de+),a
    dec     b
    jr      nz,l_i64_or_loop
    pop     hl
    add     sp,8
    jp      (hl)
