;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_open_rd.asm $
;

    SECTION code_clib
    PUBLIC  hdos_open_rd
    PUBLIC  _hdos_open_rd

    EXTERN    asm_hdos_open_rd

    INCLUDE "target/hdos/def/hdos.def"

hdos_open_rd:
_hdos_open_rd:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_open_rd
