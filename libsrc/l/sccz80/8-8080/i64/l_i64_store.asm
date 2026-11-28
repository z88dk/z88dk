; sccz80 crt0 library - 8080 version
; Store __i64_acc to the 8 bytes at bc (l_i64_store) or hl (l_i64_copy)
;
; uses  : af, de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_store
PUBLIC  l_i64_copy

EXTERN  __i64_acc

l_i64_store:
    ld      l,c
    ld      h,b
l_i64_copy:
    ex      de,hl
    ld      a,(__i64_acc+0)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+1)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+2)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+3)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+4)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+5)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+6)
    ld      (de),a
    inc     de
    ld      a,(__i64_acc+7)
    ld      (de),a
    ret
