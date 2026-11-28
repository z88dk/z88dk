; sccz80 crt0 library - 8085 version
; Load __i64_acc from the 8 bytes at hl
;
; enter : hl = source
; uses  : de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_load

EXTERN  __i64_acc

l_i64_load:
    ex      de,hl
    ld      hl,(de)
    ld      (__i64_acc+0),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (__i64_acc+2),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (__i64_acc+4),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (__i64_acc+6),hl
    ret
