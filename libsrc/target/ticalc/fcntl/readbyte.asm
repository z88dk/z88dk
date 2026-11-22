; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int readbyte(int fd) __z88dk_fastcall;
; The byte is returned in HL. HL is -1 at the end of the file.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  readbyte
    PUBLIC  _readbyte

    EXTERN  ti_slot
    EXTERN  ti_refresh
    EXTERN  ti_load
    EXTERN  ti_one
    EXTERN  ti_errno

readbyte:
_readbyte:
    ld      a, l
    call    ti_slot
    jr      c, rb_bad
    call    ti_refresh
    jr      c, rb_bad
    ld      de, ti_one
    ld      bc, 1
    call    ti_load
    ld      a, h
    or      l
    jr      z, rb_eof
    ld      a, (ti_one)
    ld      l, a
    ld      h, 0
    ret

rb_eof:
    ld      hl, -1
    ret

rb_bad:
    ld      a, EBADF
    jp      ti_errno

ENDIF
