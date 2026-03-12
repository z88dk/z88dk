;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_rename.asm $
;

    SECTION code_clib
    PUBLIC  hdos_rename
    PUBLIC  _hdos_rename

    EXTERN    asm_hdos_rename

    INCLUDE "target/hdos/def/hdos.def"

hdos_rename:
_hdos_rename:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_rename
