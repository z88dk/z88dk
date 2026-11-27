; sccz80 crt0 library - gbz80 version
; Store __i64_acc to the 8 bytes at bc (l_i64_store) or hl (l_i64_copy)
;
; uses  : af, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_store
PUBLIC  l_i64_copy

EXTERN  __i64_acc

l_i64_store:
    ld      l,c
    ld      h,b
l_i64_copy:
    ld      a,(__i64_acc+0)
    ld      (hl+),a
    ld      a,(__i64_acc+1)
    ld      (hl+),a
    ld      a,(__i64_acc+2)
    ld      (hl+),a
    ld      a,(__i64_acc+3)
    ld      (hl+),a
    ld      a,(__i64_acc+4)
    ld      (hl+),a
    ld      a,(__i64_acc+5)
    ld      (hl+),a
    ld      a,(__i64_acc+6)
    ld      (hl+),a
    ld      a,(__i64_acc+7)
    ld      (hl+),a
    ret
