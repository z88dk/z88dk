    org 0
    di
    ld sp,0x8000
    jp main
    include "../asm/8085/f32_8085_mulu_32h_32x32.asm"
main:
    ; 0x80000000 * 0x80000000 >> 32 = 0x40000000
    ld de,0x8000
    ld hl,0x0000
    push de
    push hl
    ld de,0x8000
    ld hl,0x0000
    call m32_mulu_32h_32x32
    ld a,d
    ld (0x7000),a
    ld a,e
    ld (0x7001),a
    ld a,h
    ld (0x7002),a
    ld a,l
    ld (0x7003),a

    ; 0xFFFFFFFF * 0xFFFFFFFF >> 32 = 0xFFFFFFFE
    ld de,0xFFFF
    ld hl,0xFFFF
    push de
    push hl
    ld de,0xFFFF
    ld hl,0xFFFF
    call m32_mulu_32h_32x32
    ld a,d
    ld (0x7004),a
    ld a,e
    ld (0x7005),a
    ld a,h
    ld (0x7006),a
    ld a,l
    ld (0x7007),a

    ; 0x12345678 * 0xABCDEF01 >> 32
    ld de,0xABCD
    ld hl,0xEF01
    push de
    push hl
    ld de,0x1234
    ld hl,0x5678
    call m32_mulu_32h_32x32
    ld a,d
    ld (0x7008),a
    ld a,e
    ld (0x7009),a
    ld a,h
    ld (0x700A),a
    ld a,l
    ld (0x700B),a

    halt
