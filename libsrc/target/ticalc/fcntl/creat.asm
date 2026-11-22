; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int creat(const char *name, mode_t mode);
; Opens the name with O_WRONLY, O_CREAT and O_TRUNC.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  creat
    PUBLIC  _creat
    PUBLIC  ___creat

    EXTERN  open

creat:
_creat:
___creat:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      l, (ix+2)
    ld      h, (ix+3)
    pop     ix
    push    hl
    ld      hl, O_WRONLY | O_CREAT | O_TRUNC
    push    hl
    ld      hl, 0
    push    hl
    call    open
    pop     bc
    pop     bc
    pop     bc
    ret

ENDIF
