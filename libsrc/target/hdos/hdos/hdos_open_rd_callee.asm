;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_open_rd_callee.asm $
;

; int hdos_open_rd(char *name, int channel);

    SECTION code_clib
    PUBLIC  hdos_open_rd_callee
    PUBLIC  _hdos_open_rd_callee

    EXTERN  hdos_default

    PUBLIC    asm_hdos_open_rd

    INCLUDE "target/hdos/def/hdos.def"

hdos_open_rd_callee:
_hdos_open_rd_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_open_rd:
    ld     a,c
    ld     de,hdos_default
    rst    38h
    defb   OPENR
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
