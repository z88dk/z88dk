; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; ssize_t read(int fd, void *ptr, size_t len);

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  read
    PUBLIC  _read
    PUBLIC  ___read

    EXTERN  ti_slot
    EXTERN  ti_refresh
    EXTERN  ti_load
    EXTERN  ti_errno

read:
_read:
___read:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      l, (ix+0)
    ld      h, (ix+1)
    ld      (rd_len), hl
    ld      l, (ix+2)
    ld      h, (ix+3)
    ld      (rd_ptr), hl
    ld      a, (ix+4)
    pop     ix
    call    ti_slot
    jr      c, rd_bad
    call    ti_refresh
    jr      c, rd_bad
    push    hl
    ld      de, fs_flags
    add     hl, de
    bit     5, (hl)
    pop     hl
    jr      z, rd_acces
    ld      de, (rd_ptr)
    ld      bc, (rd_len)
    jp      ti_load

rd_acces:
    ld      a, EACCES
    jp      ti_errno

rd_bad:
    ld      a, EBADF
    jp      ti_errno

    SECTION bss_clib

rd_len:
    defw    0

rd_ptr:
    defw    0

ENDIF
