; sccz80 crt0 library - VM1 version
; Store __i64_acc to the 8 bytes at bc (l_i64_store) or hl (l_i64_copy)
;
; uses  : de, hl

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
    ld      hl,(__i64_acc+0)
    ld      (de),hl
    inc     de
    inc     de
    ld      hl,(__i64_acc+2)
    ld      (de),hl
    inc     de
    inc     de
    ld      hl,(__i64_acc+4)
    ld      (de),hl
    inc     de
    inc     de
    ld      hl,(__i64_acc+6)
    ld      (de),hl
    ret
