; sccz80 crt0 library - 8080 version
; Push __i64_acc, keeping it
;
; uses  : de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_push

EXTERN  __i64_acc

l_i64_push:
    pop     de
    ld      hl,(__i64_acc+6)
    push    hl
    ld      hl,(__i64_acc+4)
    push    hl
    ld      hl,(__i64_acc+2)
    push    hl
    ld      hl,(__i64_acc+0)
    push    hl
    push    de
    ret
