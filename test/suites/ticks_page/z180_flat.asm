; -mz180 -b standard keeps the flat 64 kB.
; out0 (BBR) is still a Z180 I/O instruction. It does not move memory.
; Two result bytes at 0x0100. Stop at 0x007e.

    org 0
    jp main
    defs $7e - $
stop:
    nop
    defs $80 - $
main:
    ld a, $11
    ld ($100), a
    ld a, $10
    out0 ($39), a
    ld a, $22
    ld ($2000), a
    xor a
    out0 ($39), a
    ld a, ($2000)
    ld ($101), a            ; 22, the store stayed in the low 64k
    jp stop
