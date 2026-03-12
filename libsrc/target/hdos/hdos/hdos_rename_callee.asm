;
;   Heath/Zenith HDOS
;
;   Stefano Bodrato - 2026
;
;
;   $Id: hdos_rename_callee.asm $
;

; int hdos_rename(char *name, char *newname);

    SECTION code_clib
    PUBLIC  hdos_rename_callee
    PUBLIC  _hdos_rename_callee

    EXTERN  hdos_default

    PUBLIC    asm_hdos_rename

    INCLUDE "target/hdos/def/hdos.def"

hdos_rename_callee:
_hdos_rename_callee:
        pop     af
        pop     bc
        pop     hl
        push    af

asm_hdos_rename:
    ld     de,hdos_default
    rst    38h
    defb   RENAME
    ld     hl,1
    ret    c          ; error
    dec    hl
    ret
