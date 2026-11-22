;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_ver.asm $
;

    SECTION code_clib
    PUBLIC  hdos_ver
    PUBLIC  _hdos_ver

    INCLUDE "target/hdos/def/hdos.def"

hdos_ver:
_hdos_ver:
    rst    38h
    defb   VERS
    ld     h,0
    ld     l,a
    ret    nc
    ld     l,h
    ret
