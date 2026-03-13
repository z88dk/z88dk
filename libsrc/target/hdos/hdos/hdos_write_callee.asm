;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_write_callee.asm $
;

; int hdos_write(int channel, , int dataptr, int bytes);

    SECTION code_clib
    PUBLIC  hdos_write_callee
    PUBLIC  _hdos_write_callee

    PUBLIC    asm_hdos_write

    INCLUDE "target/hdos/def/hdos.def"

hdos_write_callee:
_hdos_write_callee:
        pop     af
        pop     bc
        pop     de
        pop     hl
        push    af

asm_hdos_write:
    ld     a,l
    rst    38h
    defb   WRITE
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
