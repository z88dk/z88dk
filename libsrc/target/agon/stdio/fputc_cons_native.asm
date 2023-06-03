
SECTION code_clib
PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native
INCLUDE "target/agon/def/mos_api.inc"

fputc_cons_native:
_fputc_cons_native:
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
again:
        push    af
        defb    $49
        rst     $10
        pop     af
        cp      10
        ret     nz
        ld      a,13
        jr      again
