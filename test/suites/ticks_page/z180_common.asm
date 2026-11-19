; SCZ180 common-1 window. The preamble sets CBAR to 0xE0 and CBR to 0xF0.
; Logical 0xF100 then reads physical 0xFF100, which starts as a copy of the
; loaded byte. A write there leaves the low 64 kB byte in place.
; Three result bytes at 0x0100. Stop at 0x007e on the reset map.
;   ab  the loaded marker, read through CBR 0xF0
;   ab  the low image after the window write
;   cd  the window write, read back through CBR 0xF0

    org 0
    jp main
    defs $7e - $
stop:
    nop
    defs $80 - $
main:
    ld a, $e0
    out0 ($3a), a           ; CBAR. Pages 0-D stay in the bank, BBR is 0.
    ld a, $f0
    out0 ($38), a           ; CBR. Page F reads physical 0xF0000 + address.
    ld a, ($f100)
    ld ($100), a            ; ab
    ld a, $cd
    ld ($f100), a           ; store into the common-1 window
    xor a
    out0 ($38), a
    ld a, $f0
    out0 ($3a), a           ; reset map
    ld a, ($f100)
    ld ($101), a            ; ab, the low byte is unchanged
    ld a, $e0
    out0 ($3a), a
    ld a, $f0
    out0 ($38), a
    ld a, ($f100)
    ld b, a                 ; cd
    xor a
    out0 ($38), a
    ld a, $f0
    out0 ($3a), a
    ld a, b
    ld ($102), a
    jp stop

    defs $f100 - $
    defb $ab

    ASSERT ($ < $f200)
