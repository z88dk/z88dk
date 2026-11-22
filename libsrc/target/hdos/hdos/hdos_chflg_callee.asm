;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_chflg_callee.asm $
;

; int hdos_chflg(char *name, int flags);

    SECTION code_clib
    PUBLIC  hdos_chflg_callee
    PUBLIC  _hdos_chflg_callee

    EXTERN  hdos_default

    PUBLIC  asm_hdos_chflg

    INCLUDE "target/hdos/def/hdos.def"

hdos_chflg_callee:
_hdos_chflg_callee:
    pop     af
    pop     bc
    pop     hl
    push    af

asm_hdos_chflg:
    ld     de,hdos_default
    ld     b,c        ; flags mask = flags
    rst    38h
    defb   CHFLG
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
