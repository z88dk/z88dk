; ED 28 on -mez80_z80. On the eZ80 this opcode takes 8 states and leaves
; the next byte to be fetched. It does not read a port into L.
; Two result bytes at 0x0100: 11 55.
; The Z180 treats the same bytes as in0 l,(n). That path is z180_mmu.asm.

    org 0
    ld l, $55
    defb $ed, $28
    ld a, $11
    ld ($100), a
    ld a, l
    ld ($101), a
stop:
    nop
