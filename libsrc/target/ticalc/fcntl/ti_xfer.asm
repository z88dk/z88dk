; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Copy bytes at the current file position. The copy stops at the end
; of the payload. An archived variable is read one byte at a time.
; ti_store does not write an archived variable.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_load
    PUBLIC  ti_store

    EXTERN  ti_arch_byte
    EXTERN  ti_arch_inc
    EXTERN  ti_arch_add

; HL = slot, DE = user buffer, BC = request. HL = bytes copied.
ti_load:
    push    hl
    push    de
    push    bc
    call    ti_at
    ld      a, b
    pop     bc
    push    hl
    call    tx_min
    pop     hl
    pop     de
    push    af
    ld      a, b
    or      c
    jr      z, tl_zero
    pop     af
    or      a
    jr      z, tl_ram
    push    bc
    push    de
    ld      d, b
    ld      e, c
    ld      b, a
tl_arch:
    ld      a, d
    or      e
    jr      z, tl_arch_done
    call    ti_arch_byte
    ex      (sp), hl
    ld      (hl), a
    inc     hl
    ex      (sp), hl
    call    ti_arch_inc
    dec     de
    jr      tl_arch

tl_arch_done:
    pop     hl
    pop     bc
    jr      tl_adv

tl_ram:
    push    bc
    ldir
    pop     bc
    jr      tl_adv

tl_zero:
    pop     af
    ld      bc, 0

tl_adv:
    pop     hl
    ld      d, b
    ld      e, c
    push    bc
    call    tx_advance
    pop     hl
    ret

; HL = slot, DE = user bytes, BC = request. HL = bytes copied.
ti_store:
    push    hl
    push    de
    push    bc
    call    ti_at
    ld      a, b
    pop     bc
    push    hl
    call    tx_min
    pop     hl
    pop     de
    push    af
    ld      a, b
    or      c
    jr      z, ts_zero
    pop     af
    or      a
    jr      nz, ts_none
    push    bc
    ex      de, hl
    ldir
    pop     bc
    jr      ts_adv

ts_none:
    ld      bc, 0
    jr      ts_adv

ts_zero:
    pop     af
    ld      bc, 0

ts_adv:
    pop     hl
    ld      d, b
    ld      e, c
    push    bc
    call    tx_advance
    pop     hl
    ret

; HL = slot. B = page, HL = address, DE = bytes from here to the end.
ti_at:
    ld      de, fs_page
    add     hl, de
    ld      c, (hl)
    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    push    de
    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    push    de
    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    pop     hl
    push    hl
    ex      de, hl
    or      a
    sbc     hl, de
    jr      nc, at_room
    ld      hl, 0
at_room:
    pop     de
    ex      (sp), hl
    ld      a, c
    or      a
    jr      nz, at_arch
    add     hl, de
    pop     de
    ld      b, 0
    ret

at_arch:
    ld      b, c
    call    ti_arch_add
    pop     de
    ret

; BC = min(BC, DE).
tx_min:
    ld      h, b
    ld      l, c
    push    hl
    or      a
    sbc     hl, de
    pop     hl
    ret     c
    ld      b, d
    ld      c, e
    ret

; HL = slot, DE = bytes to add to the position.
tx_advance:
    push    hl
    ld      bc, fs_pos
    add     hl, bc
    ld      c, (hl)
    inc     hl
    ld      b, (hl)
    dec     hl
    ex      de, hl
    add     hl, bc
    ex      de, hl
    ld      (hl), e
    inc     hl
    ld      (hl), d
    pop     hl
    ret

ENDIF
