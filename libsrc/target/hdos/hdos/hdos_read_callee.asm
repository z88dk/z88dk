;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_read_callee.asm $
;

; int hdos_read(int channel, int addr, int dataptr, int bytes);

    SECTION code_clib
    PUBLIC  hdos_read_callee
    PUBLIC  _hdos_read_callee

    PUBLIC    asm_hdos_read

    INCLUDE "target/hdos/def/hdos.def"

hdos_read_callee:
_hdos_read_callee:
        pop     af
        pop     bc
        pop     de
        pop     hl
        push    af

asm_hdos_read:
    ld     a,l
    rst    38h
    defb   READ
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
