SECTION code_clib

PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native

INCLUDE "target/alphatp2/def/alphatp2.def"

; page 79 in SystemHandbuch for codes

fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a,(hl)
    cp      10
    jp      nz,notlf
    ld      c,a
    call    DISPE
    ld      a,13
notlf:
    ld      c, a
    call    DISPE
    ret
