;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_open_upd_callee.asm $
;

; int hdos_open_upd(char *name, int channel);

    SECTION code_clib
    PUBLIC  hdos_open_upd_callee
    PUBLIC  _hdos_open_upd_callee

    EXTERN  hdos_default

    PUBLIC    asm_hdos_open_upd

    INCLUDE "target/hdos/def/hdos.def"

hdos_open_upd_callee:
_hdos_open_upd_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_open_upd:
	ld     a,c
    ld     de,hdos_default
    rst    38h
    defb   OPENU
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
