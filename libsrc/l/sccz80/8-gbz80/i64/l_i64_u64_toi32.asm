; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; sccz80 crt0 library - gbz80 version
; Truncate __i64_acc to the low 32 bits.
;
; enter : __i64_acc = value
; exit  : dehl = that value, bc preserved

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_u64_toi32
PUBLIC  l_i64_s64_toi32

EXTERN  __i64_acc

l_i64_u64_toi32:
l_i64_s64_toi32:
    ld      a,(__i64_acc+2)
    ld      e,a
    ld      a,(__i64_acc+3)
    ld      d,a
    ld      a,(__i64_acc+0)
    ld      l,a
    ld      a,(__i64_acc+1)
    ld      h,a
    ret
