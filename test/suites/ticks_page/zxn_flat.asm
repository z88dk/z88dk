; -mz80n -b standard keeps the flat 64 kB.
; nextreg still executes. It does not move memory.
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
    nextreg $56, $10
    ld a, $22
    ld ($c000), a
    nextreg $56, $11
    ld a, ($c000)
    ld ($101), a            ; 22, the store stayed in the low 64k
    nextreg $56, $ff
    jp stop
