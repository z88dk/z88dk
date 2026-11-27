; sccz80 crt0 library - 8080 version
; Count the significant bytes of a 64-bit value
;
; enter : hl = address of the top byte (value + 7)
; exit  : b = number of bytes up to and including the highest non-zero one
; uses  : af, b, hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_i64_sig_8080

l_i64_sig_8080:
    ld      b,8
l_i64_sig_8080_1:
    ld      a,(hl)
    or      a
    ret     nz
    dec     hl
    dec     b
    jp      nz,l_i64_sig_8080_1
    ret
