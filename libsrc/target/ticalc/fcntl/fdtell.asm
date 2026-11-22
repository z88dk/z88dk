; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; long fdtell(int fd);

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  fdtell
    PUBLIC  _fdtell

    EXTERN  ti_slot
    EXTERN  ti_refresh
    EXTERN  ti_errno_l

fdtell:
_fdtell:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      a, (ix+0)
    pop     ix
    call    ti_slot
    jr      c, ft_bad
    call    ti_refresh
    jr      c, ft_bad
    ld      de, fs_pos
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    ld      de, 0
    ret

ft_bad:
    ld      a, EBADF
    jp      ti_errno_l

ENDIF
