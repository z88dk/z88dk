    org 0
    ld sp,0x3000
    ld a,0xc0
    ioi ld (0x420),a       ; EDMR: R4K instruction set
    ld a,0x84
    ioi ld (0x13),a        ; SEGSIZE: data from 0x4000, stack from 0x8000
    ld a,0x34
    ioi ld (0x1e),a        ; DATSEGL
    ld a,0x0a
    ioi ld (0x1f),a        ; DATSEGH: data offset 0xa34 * 4k
    ld a,0x01
    ioi ld (0x1a),a        ; STKSEGL
    ld a,0x02
    ioi ld (0x1b),a        ; STKSEGH: stack offset 0x201 * 4k
    ld a,0x77
    ld (0x4010),a          ; physical 0xa34000 + 0x4010
    ld a,0x88
    ld (0x8005),a          ; physical 0x201000 + 0x8005
    ldf a,(0xa38010)
    ld (0x0100),a
    ldf a,(0x209005)
    ld (0x0101),a
    ld a,0x10
    ioi ld (0x12),a        ; DATASEG: low byte only, DATSEGH is cleared
    ld a,0x99
    ld (0x4010),a          ; physical 0x10000 + 0x4010
    ldf a,(0x014010)
    ld (0x0102),a
    ioi ld a,(0x1e)
    ld (0x0103),a
    ioi ld a,(0x1f)
    ld (0x0104),a
done:
    nop
