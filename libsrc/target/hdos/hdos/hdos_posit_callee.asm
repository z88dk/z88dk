;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_posit_callee.asm $
;

; int hdos_posit(int channel, int sector);

    SECTION code_clib
    PUBLIC  hdos_posit_callee
    PUBLIC  _hdos_posit_callee

    PUBLIC    asm_hdos_posit

    INCLUDE "target/hdos/def/hdos.def"

hdos_posit_callee:
_hdos_posit_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_posit:
    ld     a,l
    rst    38h
    defb   POSIT
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
