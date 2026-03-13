;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_read.asm $
;

    SECTION code_clib
    PUBLIC  hdos_read
    PUBLIC  _hdos_read

    EXTERN    asm_hdos_read

    INCLUDE "target/hdos/def/hdos.def"

hdos_read:
_hdos_read:
        pop     af
        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        push    af
        jp      asm_hdos_read
