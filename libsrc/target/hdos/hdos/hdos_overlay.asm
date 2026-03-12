;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_overlay.asm $
;

    SECTION code_clib
    PUBLIC  hdos_overlay
    PUBLIC  _hdos_overlay

    INCLUDE "target/hdos/def/hdos.def"

hdos_overlay:
_hdos_overlay:
    ld     a,h
    rst    38h
    defb   LOADO
    ld     hl,1
    ret    c          ; Overlay load error
    dec    hl
    ret
