; sccz80 crt0 library - 8080 version
; Copy 8 bytes
;
; enter : hl = source, de = destination
; exit  : hl, de advanced by 8
; uses  : af, b, de, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_cp8

l_i64_cp8:
    ld      b,8
l_i64_cp8_1:
    ld      a,(hl)
    ld      (de),a
    inc     hl
    inc     de
    dec     b
    jp      nz,l_i64_cp8_1
    ret
