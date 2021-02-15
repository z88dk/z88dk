
    SECTION code_clib
    PUBLIC fputc_cons_native
    PUBLIC _fputc_cons_native


    INCLUDE "target/radio86/def/monitor.def"

fputc_cons_native:
_fputc_cons_native:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    cp      10
    jp      nz,PUTCHAR
    ld      a,13
    jp      PUTCHAR
    
