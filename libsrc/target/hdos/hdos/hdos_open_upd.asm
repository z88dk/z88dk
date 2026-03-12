;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_open_upd.asm $
;

    SECTION code_clib
    PUBLIC  hdos_open_upd
    PUBLIC  _hdos_open_upd

    EXTERN    asm_hdos_open_upd

    INCLUDE "target/hdos/def/hdos.def"

hdos_open_upd:
_hdos_open_upd:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_open_upd
