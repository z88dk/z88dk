; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int rename(const char *old, const char *new);
; The TI-83 Plus variable table has no rename entry.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  rename
    PUBLIC  _rename
    PUBLIC  ___rename

    EXTERN  ti_errno

rename:
_rename:
___rename:
    ld      a, ENOTSUP
    jp      ti_errno

ENDIF
