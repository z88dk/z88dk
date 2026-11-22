; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; long lseek(int fd, long posn, int whence);
; The position stays inside the file. A negative result becomes 0
; and a result past the end becomes the file size.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  lseek
    PUBLIC  _lseek
    PUBLIC  ___lseek

    EXTERN  ti_slot
    EXTERN  ti_refresh
    EXTERN  ti_errno_l

lseek:
_lseek:
___lseek:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      a, (ix+0)
    ld      (ls_how), a
    ld      l, (ix+2)
    ld      h, (ix+3)
    ld      (ls_low), hl
    ld      l, (ix+4)
    ld      h, (ix+5)
    ld      (ls_high), hl
    ld      a, (ix+6)
    pop     ix
    call    ti_slot
    jp      c, ls_bad
    call    ti_refresh
    jp      c, ls_bad
    ld      (ls_slot), hl
    ld      a, (ls_how)
    or      a
    jr      z, ls_set
    dec     a
    jr      z, ls_cur
    dec     a
    jr      nz, ls_inval
    ld      de, fs_size
    jr      ls_base

ls_cur:
    ld      de, fs_pos

ls_base:
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    jr      ls_off

ls_set:
    ld      de, 0

ls_off:
    ld      hl, (ls_high)
    ld      a, h
    or      l
    jr      z, ls_hi0
    ld      a, h
    and     l
    cp      $ff
    jr      z, ls_neg
    bit     7, h
    jr      nz, ls_zero
    jr      ls_endpos

ls_hi0:
    ld      hl, (ls_low)
    add     hl, de
    jr      c, ls_endpos
    jr      ls_clamp

ls_neg:
    ld      hl, (ls_low)
    add     hl, de
    jr      nc, ls_zero

ls_clamp:
    push    hl
    ld      hl, (ls_slot)
    ld      de, fs_size
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    pop     hl
    push    hl
    or      a
    sbc     hl, de
    pop     hl
    jr      c, ls_store
    jr      z, ls_store
    ld      h, d
    ld      l, e
    jr      ls_store

ls_zero:
    ld      hl, 0
    jr      ls_store

ls_endpos:
    ld      hl, (ls_slot)
    ld      de, fs_size
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl

ls_store:
    push    hl
    ld      hl, (ls_slot)
    ld      de, fs_pos
    add     hl, de
    pop     de
    ld      (hl), e
    inc     hl
    ld      (hl), d
    ex      de, hl
    ld      de, 0
    ret

ls_bad:
    ld      a, EBADF
    jp      ti_errno_l

ls_inval:
    ld      a, EINVAL
    jp      ti_errno_l

    SECTION bss_clib

ls_low:
    defw    0

ls_high:
    defw    0

ls_slot:
    defw    0

ls_how:
    defb    0

ENDIF
