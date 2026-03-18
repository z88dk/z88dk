;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_decode_callee.asm $
;

; int hdos_decode(char *name, char *fcb);

    SECTION code_clib
    PUBLIC  hdos_decode_callee
    PUBLIC  _hdos_decode_callee

    EXTERN  hdos_default

    PUBLIC    asm_hdos_decode

    INCLUDE "target/hdos/def/hdos.def"

hdos_decode_callee:
_hdos_decode_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_decode:
    ld     a,c
    ld     de,hdos_default
    rst    38h
    defb   DECODE
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
