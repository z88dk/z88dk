    org 0
    ld sp,0x3000
    ld a,0x84
    ioi ld (0x13),a        ; SEGSIZE: data from 0x4000, stack from 0x8000
    ld a,0x10
    ioi ld (0x12),a        ; DATASEG
    ld a,0x20
    ioi ld (0x11),a        ; STACKSEG
    ld hl,0xBEEF
    ld (0x4000),hl         ; phys 0x14000
    ld a,1
    ldp hl,(0x4000)
    ld (0x0100),hl
    ld hl,0xCAFE
    ld (0x8000),hl         ; phys 0x28000
    ld a,2
    ldp hl,(0x8000)
    ld (0x0102),hl
    ld hl,0x55AA
    ld a,9
    ldp (0x1234),hl        ; phys 0x91234
    ld a,0x83
    ld xpc,a
    ld hl,(0xE234)         ; 0x83000 + 0xE234
    ld (0x0104),hl
    ld a,xpc
    ld (0x0106),a
    ld a,0x11
    ld xpc,a
    lcall 0x44,sub
    ld a,xpc
    ld (0x0107),a
    ld hl,0x1357
    ld a,3
    ld iy,0x4000
    ldp (iy),hl            ; phys 0x34000
    ld a,0
    ldp hl,(0x4000)        ; logical data seg is 0x14000, not 0x04000 -> 0
    ld (0x010a),hl
    ld a,3
    ldp hl,(0x4000)
    ld (0x010c),hl
    jr done
sub:
    ld a,xpc
    ld (0x0108),a
    lret
done:
    nop
