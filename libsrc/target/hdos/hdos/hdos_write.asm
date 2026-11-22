;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_write.asm $
;

    SECTION code_clib
    PUBLIC  hdos_write
    PUBLIC  _hdos_write

    EXTERN    asm_hdos_write

    INCLUDE "target/hdos/def/hdos.def"

hdos_write:
_hdos_write:
        pop     af
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        push    af
        jp      asm_hdos_write
