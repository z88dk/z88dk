; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; ssize_t write(int fd, const void *ptr, size_t len);
;
; A write that would pass the end of a fixed variable writes nothing.
; A resizable RAM variable grows when the write passes the end. When
; there is not enough free RAM, the bytes that already fit are written.
; An archived variable accepts none of the bytes.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  write
    PUBLIC  _write
    PUBLIC  ___write

    EXTERN  ti_slot
    EXTERN  ti_refresh
    EXTERN  ti_store
    EXTERN  ti_grow
    EXTERN  ti_errno

write:
_write:
___write:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      l, (ix+0)
    ld      h, (ix+1)
    ld      (wr_len), hl
    ld      l, (ix+2)
    ld      h, (ix+3)
    ld      (wr_ptr), hl
    ld      a, (ix+4)
    pop     ix
    call    ti_slot
    jp      c, wr_bad
    call    ti_refresh
    jp      c, wr_bad
    ld      (wr_slot), hl
    ld      de, fs_flags
    add     hl, de
    bit     1, (hl)
    jp      z, wr_acces
    bit     3, (hl)
    jp      nz, wr_none
    ld      hl, (wr_len)
    ld      a, h
    or      l
    jp      z, wr_none
    ld      hl, (wr_slot)
    ld      de, fs_pos
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (wr_pos), de
    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (wr_size), de
    ld      hl, (wr_size)
    ld      de, (wr_pos)
    or      a
    sbc     hl, de
    jr      nc, wr_have
    ld      hl, 0
wr_have:
    ld      (wr_room), hl
    ld      de, (wr_len)
    or      a
    sbc     hl, de
    jr      c, wr_past
    ld      hl, (wr_slot)
    ld      de, (wr_ptr)
    ld      bc, (wr_len)
    jp      ti_store

wr_past:
    ld      hl, (wr_slot)
    ld      de, fs_flags
    add     hl, de
    bit     2, (hl)
    jp      z, wr_none
    ld      hl, (wr_pos)
    ld      de, (wr_len)
    add     hl, de
    jp      c, wr_short
    ld      (wr_new), hl
    ld      de, (wr_size)
    or      a
    sbc     hl, de
    jp      c, wr_short
    ld      (wr_extra), hl
    ld      hl, (wr_extra)
    call    ti_grow
    jp      c, wr_short
    ld      hl, (wr_slot)
    call    ti_refresh
    jp      c, wr_bad
    ld      de, fs_off
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (wr_at), de
    ld      hl, (wr_slot)
    ld      de, fs_size
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      hl, (wr_at)
    add     hl, de
    jp      c, wr_short
    ex      de, hl
    ld      hl, (wr_extra)
    TICALL  InsertMem
    ld      hl, (wr_at)
    dec     hl
    dec     hl
    ld      de, (wr_new)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    ld      hl, (wr_slot)
    call    ti_refresh
    jp      c, wr_bad
    ld      hl, (wr_slot)
    ld      de, (wr_ptr)
    ld      bc, (wr_len)
    jp      ti_store

wr_short:
    ld      hl, (wr_slot)
    ld      de, (wr_ptr)
    ld      bc, (wr_len)
    jp      ti_store

wr_none:
    ld      hl, 0
    ret

wr_acces:
    ld      a, EACCES
    jp      ti_errno

wr_bad:
    ld      a, EBADF
    jp      ti_errno

    SECTION bss_clib

wr_len:
    defw    0

wr_ptr:
    defw    0

wr_slot:
    defw    0

wr_pos:
    defw    0

wr_size:
    defw    0

wr_room:
    defw    0

wr_new:
    defw    0

wr_extra:
    defw    0

wr_at:
    defw    0

ENDIF
