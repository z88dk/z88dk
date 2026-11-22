;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_open_wr.asm $
;

    SECTION code_clib
    PUBLIC  hdos_open_wr
    PUBLIC  _hdos_open_wr

    EXTERN    asm_hdos_open_wr

    INCLUDE "target/hdos/def/hdos.def"

hdos_open_wr:
_hdos_open_wr:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_open_wr
