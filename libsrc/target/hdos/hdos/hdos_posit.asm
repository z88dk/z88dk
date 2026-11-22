;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_posit.asm $
;

    SECTION code_clib
    PUBLIC  hdos_posit
    PUBLIC  _hdos_posit

    EXTERN    asm_hdos_posit

    INCLUDE "target/hdos/def/hdos.def"

hdos_posit:
_hdos_posit:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_posit
