; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int open(const char *name, int flags, mode_t mode);
;
; A bare name is an AppVar. "T:name" selects the type in ti_name.
; Only an AppVar is created, and only when O_CREAT is set.
; O_TRUNC on an archived variable or a fixed-size type fails.
; The mode argument is ignored.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  open
    PUBLIC  _open
    PUBLIC  ___open

    EXTERN  ti_slot_new
    EXTERN  ti_name
    EXTERN  ti_find
    EXTERN  ti_create
    EXTERN  ti_geom
    EXTERN  ti_shrink
    EXTERN  ti_errno

open:
_open:
___open:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      l, (ix+4)
    ld      h, (ix+5)
    ld      (op_name), hl
    ld      a, (ix+2)
    ld      (op_low), a
    ld      a, (ix+3)
    ld      (op_high), a
    pop     ix

    call    ti_slot_new
    jp      c, op_emfile
    ld      (op_fd), a
    ld      (op_slot), hl
    ld      hl, (op_name)
    call    ti_name
    jp      c, op_inval
    ld      hl, OP1
    ld      de, (op_slot)
    ld      bc, 9
    ldir
    call    ti_find
    jr      nc, op_got
    ld      a, (op_high)
    bit     2, a
    jp      z, op_inval
    ld      hl, (op_slot)
    ld      a, (hl)
    cp      AppVarObj
    jp      nz, op_inval
    call    ti_create
    jp      c, op_nomem

op_got:
    ld      (op_vat), hl
    call    ti_geom
    jp      c, op_inval
    ld      (op_geom), a
    ld      a, b
    ld      (op_page), a
    ld      (op_addr), de
    ld      (op_size), hl
    ld      a, (op_high)
    bit     1, a
    jr      z, op_place
    ld      a, (op_geom)
    bit     3, a
    jp      nz, op_acces
    bit     2, a
    jp      z, op_inval
    ld      hl, (op_size)
    ld      a, h
    or      l
    jr      z, op_place
    ld      de, (op_addr)
    call    ti_shrink
    ld      hl, 0
    ld      (op_size), hl
    ld      hl, (op_addr)
    dec     hl
    dec     hl
    xor     a
    ld      (hl), a
    inc     hl
    ld      (hl), a

op_place:
    ld      hl, 0
    ld      a, (op_high)
    bit     0, a
    jr      z, op_setpos
    ld      hl, (op_size)
op_setpos:
    ld      (op_posn), hl
    ld      a, (op_geom)
    and     TI_ARCH | TI_GROW | TI_HSIZE
    or      TI_OPEN
    ld      c, a
    ld      a, (op_low)
    and     3
    jr      z, op_ro
    ld      a, c
    or      TI_WRITE
    ld      c, a
op_ro:
    ld      hl, (op_slot)
    ld      de, fs_page
    add     hl, de
    ld      a, (op_page)
    ld      (hl), a
    inc     hl
    ld      de, (op_addr)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    ld      de, (op_posn)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    ld      de, (op_size)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    ld      (hl), c
    inc     hl
    ld      de, (op_vat)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    ld      a, (op_fd)
    ld      l, a
    ld      h, 0
    ret

op_emfile:
    ld      a, EMFILE
    jp      ti_errno

op_nomem:
    ld      a, ENOMEM
    jp      ti_errno

op_acces:
    ld      a, EACCES
    jp      ti_errno

op_inval:
    ld      a, EINVAL
    jp      ti_errno

    SECTION bss_clib

op_name:
    defw    0

op_slot:
    defw    0

op_vat:
    defw    0

op_addr:
    defw    0

op_size:
    defw    0

op_posn:
    defw    0

op_fd:
    defb    0

op_low:
    defb    0

op_high:
    defb    0

op_page:
    defb    0

op_geom:
    defb    0

ENDIF
