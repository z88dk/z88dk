;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_delete.asm $
;

    SECTION code_clib
    PUBLIC  hdos_delete
    PUBLIC  _hdos_delete

    EXTERN  hdos_default

    INCLUDE "target/hdos/def/hdos.def"

hdos_delete:
_hdos_delete:
    ld     de,hdos_default
    rst    38h
    defb   DELETE
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
