;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_close.asm $
;

    SECTION code_clib
    PUBLIC  hdos_close
    PUBLIC  _hdos_close

    INCLUDE "target/hdos/def/hdos.def"

hdos_close:
_hdos_close:
    ld     a,h
    rst    38h
    defb   LOADO
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
