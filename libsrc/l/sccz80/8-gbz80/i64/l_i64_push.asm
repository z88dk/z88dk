; sccz80 crt0 library - gbz80 version
; Push __i64_acc, keeping it
;
; uses  : af, bc, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_push

EXTERN  __i64_acc

l_i64_push:
    pop     bc
    add     sp,-8
    ld      hl,sp+0
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
    push    bc
    ret
