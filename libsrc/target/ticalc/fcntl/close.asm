; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int close(int fd);

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  close
    PUBLIC  _close

    EXTERN  ti_slot
    EXTERN  ti_errno

close:
_close:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      a, (ix+0)
    pop     ix
    call    ti_slot
    jr      c, cl_bad
    ld      de, fs_flags
    add     hl, de
    ld      (hl), 0
    ld      hl, 0
    ret

cl_bad:
    ld      a, EBADF
    jp      ti_errno

ENDIF
