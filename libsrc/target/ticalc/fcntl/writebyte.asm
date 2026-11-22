; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int writebyte(int fd, int c);
; Returns the byte written, or -1 when the byte is not written.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  writebyte
    PUBLIC  _writebyte
    PUBLIC  ___writebyte

    EXTERN  write
    EXTERN  ti_one

writebyte:
_writebyte:
___writebyte:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      l, (ix+2)
    ld      h, (ix+3)
    ld      a, (ix+0)
    pop     ix
    ld      (ti_one), a
    push    hl
    ld      hl, ti_one
    push    hl
    ld      hl, 1
    push    hl
    call    write
    pop     bc
    pop     bc
    pop     bc
    ld      a, h
    or      a
    jr      nz, wb_fail
    ld      a, l
    cp      1
    jr      nz, wb_fail
    ld      a, (ti_one)
    ld      l, a
    ld      h, 0
    ret

wb_fail:
    bit     7, h
    ret     nz
    ld      hl, -1
    ret

ENDIF
