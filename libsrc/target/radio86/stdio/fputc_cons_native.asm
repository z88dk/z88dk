
    SECTION code_clib
    PUBLIC fputc_cons_native
    PUBLIC _fputc_cons_native


    INCLUDE "target/radio86/def/monitor.def"

fputc_cons_native:
_fputc_cons_native:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    ld      c,a
    cp      10
    jp      nz,not_lf
    ld      c,13
print:
    jp      PUTCHAR
not_lf:
    cp      12
    jp      nz,PUTCHAR
    ld      c,$1f
    jp      PUTCHAR
    
