
    SECTION code_clib
    PUBLIC  fputc_cons_native
    PUBLIC  _fputc_cons_native


    INCLUDE "target/radio86/def/radio86.h"

fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    ld      c, a
    cp      10
    jp      nz, not_lf
    ld      c, 13
print:
    jp      M_PUTCHAR
not_lf:
    cp      12
    jp      nz, M_PUTCHAR
    ld      c, $1f
    jp      M_PUTCHAR

