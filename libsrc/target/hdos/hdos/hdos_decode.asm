;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_decode.asm $
;

    SECTION code_clib
    PUBLIC  hdos_decode
    PUBLIC  _hdos_decode

    EXTERN    asm_hdos_decode

    INCLUDE "target/hdos/def/hdos.def"

hdos_decode:
_hdos_decode:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_decode
