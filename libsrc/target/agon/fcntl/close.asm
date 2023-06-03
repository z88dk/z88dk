SECTION code_clib

PUBLIC close
PUBLIC _close

INCLUDE "target/agon/def/mos_api.inc"

close:
_close:
    pop     de
    pop     bc
    push    bc
    push    de
    push    ix
    MOSCALL(mos_fclose)
    ld      hl,0
    pop     ix
    ret
