; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Set errno and return HL = -1, or DEHL = -1.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_errno
    PUBLIC  ti_errno_l

    EXTERN  _errno

ti_errno:
    ld      l, a
    ld      h, 0
    ld      (_errno), hl
    ld      hl, -1
    ret

ti_errno_l:
    call    ti_errno
    ld      de, hl
    ret

ENDIF
