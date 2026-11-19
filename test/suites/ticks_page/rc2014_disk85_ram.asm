; RAM image for the 8085 disk harness.
; Byte 0 of this file is RAM address 0 on page 0.
; The name contains rc2014. A positional load would plant the hook.
; Offset 0 is the initialised byte. Offset 8 stays 0.
; The runner sits at offset 0x8000. The ROM image jumps here.
; The pass line is BDOS_DISK_OK through the syscall trap.
; Port 0x30 is not used. SP starts at 0.
; -end 8100 stops on the jump. The six bytes there are the results.

    org 0

    defb $12
    defs $0008 - $
    defb 0
    defs $8000 - $

    xor a
    out ($38), a
    ld hl, $7893
copy:
    ld a, (hl)
    ld (hl), a
    inc hl
    ld a, h
    cp $80
    jp nz, copy

    ld a, 1
    out ($38), a

    xor a
    out ($38), a
    ld hl, $7628
    ld (hl), $77
    ld a, 1
    out ($38), a

    ld hl, $7131
next:
    xor a
    out ($38), a
    ld a, (hl)
    ld b, a
    ld a, 1
    out ($38), a
    ld a, b
    or a
    jp z, noted

    push hl
    ld l, a
    ld a, 1
    call syscall
    pop hl
    inc hl
    jp next

noted:
    ld l, 10
    ld a, 1
    call syscall

    ld a, ($7893)
    ld ($8100), a
    ld a, ($7894)
    ld ($8101), a
    ld a, ($7628)
    ld ($8102), a
    ld a, ($7131)
    ld ($8103), a
    ld a, ($0000)
    ld ($8104), a
    ld a, ($0008)
    ld ($8105), a
    jp $8100

syscall:
    defb $ed, $fe
    ret

    ASSERT $ < $8100
