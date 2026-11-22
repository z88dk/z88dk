; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Read one archive byte and move a window address.
; The window is 4000h-7FFFh. A sector starts when the page is a multiple of 4,
; and 4000h on that page is a status byte, not variable data.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_arch_byte
    PUBLIC  ti_arch_inc
    PUBLIC  ti_arch_add

; B = page, HL = address. A = byte. B, HL and DE are kept.
ti_arch_byte:
    push    bc
    push    de
    push    hl
    TICALL  _LoadCIndPaged
    ld      a, c
    pop     hl
    pop     de
    pop     bc
    ret

; BHL points at the next address. A sector status byte is skipped.
; The first page of a sector has that byte at 4000h.
ti_arch_inc:
    inc     hl
    bit     7, h
    ret     z
    call    ta_wrap
    ld      a, b
    and     3
    ret     nz
    inc     hl
    bit     7, h
    ret     z
    jp      ta_wrap

; Add DE to BHL. The add may cross more than one page.
; A sector status byte is not part of the variable.
ti_arch_add:
    ld      a, d
    or      e
    ret     z
ta_loop:
    push    hl
    push    de
    ld      de, hl
    ld      hl, $8000
    or      a
    sbc     hl, de
    pop     de
    ld      a, h
    or      l
    jr      z, ta_next
    push    hl
    or      a
    sbc     hl, de
    pop     hl
    jr      z, ta_cross
    jr      c, ta_cross
    pop     hl
    add     hl, de
    ret

ta_cross:
    ex      de, hl
    or      a
    sbc     hl, de
    ex      de, hl
ta_next:
    pop     hl
    call    ta_wrap
    ld      a, b
    and     3
    jr      nz, ta_loop
    inc     hl
    jr      ta_loop

ta_wrap:
    inc     b
    ld      hl, $4000
    ret

ENDIF
