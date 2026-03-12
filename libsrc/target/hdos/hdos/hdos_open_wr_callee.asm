;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_open_wr_callee.asm $
;

; int hdos_open_wr(char *name, int channel);

    SECTION code_clib
    PUBLIC  hdos_open_wr_callee
    PUBLIC  _hdos_open_wr_callee

    EXTERN  hdos_default

    PUBLIC    asm_hdos_open_wr

    INCLUDE "target/hdos/def/hdos.def"

hdos_open_wr_callee:
_hdos_open_wr_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_open_wr:
    ld     a,c
    ld     de,hdos_default
    rst    38h
    defb   OPENW
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
