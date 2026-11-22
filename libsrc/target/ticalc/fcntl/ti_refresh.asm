; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Find the slot's variable again and refresh its address and size.
; InsertMem moves RAM, so a stored address is not kept across a call.
; OPEN and WRITE are kept. The file position is kept, and clamped to
; the new size.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_refresh

    EXTERN  ti_find
    EXTERN  ti_geom

; HL = slot. Carry set when the variable is gone or the header is bad.
ti_refresh:
    push    hl
    ld      de, OP1
    ld      bc, 9
    ldir
    call    ti_find
    jr      c, tr_miss
    call    ti_geom
    jr      c, tr_miss
    ld      (tr_flags), a
    ld      a, b
    ld      (tr_page), a
    ld      (tr_addr), de
    ld      (tr_size), hl
    pop     hl
    push    hl
    ld      de, fs_page
    add     hl, de
    ld      a, (tr_page)
    ld      (hl), a
    inc     hl
    ld      de, (tr_addr)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    inc     hl
    inc     hl
    ld      de, (tr_size)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    ld      a, (hl)
    and     TI_OPEN | TI_WRITE | TI_READ
    ld      c, a
    ld      a, (tr_flags)
    and     TI_ARCH | TI_GROW
    or      c
    ld      (hl), a
    pop     hl
    push    hl
    ld      de, fs_pos
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      c, (hl)
    inc     hl
    ld      b, (hl)
    push    hl
    ld      h, d
    ld      l, e
    or      a
    sbc     hl, bc
    pop     hl
    jr      c, tr_pos
    jr      z, tr_pos
    dec     hl
    dec     hl
    ld      (hl), b
    dec     hl
    ld      (hl), c
tr_pos:
    pop     hl
    or      a
    ret

tr_miss:
    pop     hl
    scf
    ret

    SECTION bss_clib

tr_addr:
    defw    0

tr_size:
    defw    0

tr_page:
    defb    0

tr_flags:
    defb    0

ENDIF
