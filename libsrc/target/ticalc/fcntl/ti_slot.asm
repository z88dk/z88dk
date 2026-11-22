; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Map a file descriptor to its slot.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_slot
    PUBLIC  ti_slot_new

    EXTERN  ti_files

; A = fd. HL = slot and carry clear when that slot is open.
ti_slot:
    cp      TI_MIN_FD
    ret     c
    cp      TI_MIN_FD + TI_NSLOTS
    ccf
    ret     c
    sub     TI_MIN_FD
    ld      c, a
    ld      l, a
    ld      h, 0
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de
    ld      e, c
    ld      d, 0
    add     hl, de
    ld      de, ti_files
    add     hl, de
    push    hl
    ld      de, fs_flags
    add     hl, de
    bit     0, (hl)
    pop     hl
    scf
    ret     z
    or      a
    ret

; HL = free slot, A = fd. Carry set when every slot is open.
ti_slot_new:
    ld      hl, ti_files
    ld      b, TI_NSLOTS
    ld      c, TI_MIN_FD
sn_loop:
    push    hl
    ld      de, fs_flags
    add     hl, de
    bit     0, (hl)
    pop     hl
    jr      z, sn_got
    ld      de, TI_SLOT
    add     hl, de
    inc     c
    djnz    sn_loop
    scf
    ret

sn_got:
    ld      a, c
    or      a
    ret

ENDIF
