;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_chflg.asm $
;

    SECTION code_clib
    PUBLIC  hdos_chflg
    PUBLIC  _hdos_chflg

    EXTERN    asm_hdos_chflg

    INCLUDE "target/hdos/def/hdos.def"

hdos_chflg:
_hdos_chflg:
        pop     af
        pop     bc
        pop     hl
        push    hl
        push    bc
        push    af
        jp      asm_hdos_chflg
