; sccz80 crt0 library - gbz80 version
; Load __i64_acc from the 8 bytes at hl
;
; enter : hl = source
; uses  : af, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_load

EXTERN  __i64_acc

l_i64_load:
    ld      a,(hl+)
    ld      (__i64_acc+0),a
    ld      a,(hl+)
    ld      (__i64_acc+1),a
    ld      a,(hl+)
    ld      (__i64_acc+2),a
    ld      a,(hl+)
    ld      (__i64_acc+3),a
    ld      a,(hl+)
    ld      (__i64_acc+4),a
    ld      a,(hl+)
    ld      (__i64_acc+5),a
    ld      a,(hl+)
    ld      (__i64_acc+6),a
    ld      a,(hl+)
    ld      (__i64_acc+7),a
    ret
