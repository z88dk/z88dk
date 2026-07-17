    org 0
    di
    ld sp,0x8000
    ; float16(3) = 0x40400000
    ld hl,3
    call m32_float16
    ld a,d
    ld (0x7000),a
    ld a,e
    ld (0x7001),a
    ld a,h
    ld (0x7002),a
    ld a,l
    ld (0x7003),a
    ; float16(-2) = 0xc0000000
    ld hl,-2
    call m32_float16
    ld a,d
    ld (0x7004),a
    ld a,e
    ld (0x7005),a
    ld a,h
    ld (0x7006),a
    ld a,l
    ld (0x7007),a
    ; float32 0x80000000 → -2^31 = 0xcf000000
    ld de,0x8000
    ld hl,0
    call m32_float32
    ld a,d
    ld (0x7008),a
    ld a,e
    ld (0x7009),a
    ld a,h
    ld (0x700A),a
    ld a,l
    ld (0x700B),a
    ; float16u(1) = 0x3f800000
    ld hl,1
    call m32_float16u
    ld a,d
    ld (0x700C),a
    ld a,e
    ld (0x700D),a
    ld a,h
    ld (0x700E),a
    ld a,l
    ld (0x700F),a
    halt
    include "../asm/8085/f32_fsconv.asm"
    include "../asm/8085/f32_fsnormalize.asm"
