    org 0
    di
    ld sp,0x8000
    jp main

    include "../asm/8085/f32_fsadd.asm"
    include "../asm/8085/f32_fsnormalize.asm"

main:
    ; 1.0 + 2.0 = 3.0
    ; 1.0=0x3f800000 2.0=0x40000000 3.0=0x40400000
    ld de,0x3f80
    ld hl,0x0000
    push de
    push hl
    ld de,0x4000
    ld hl,0x0000
    call m32_fsadd_callee
    ld a,d
    ld (0x7000),a
    ld a,e
    ld (0x7001),a
    ld a,h
    ld (0x7002),a
    ld a,l
    ld (0x7003),a

    ; 1.5 + 1.5 = 3.0
    ld de,0x3fc0
    ld hl,0x0000
    push de
    push hl
    ld de,0x3fc0
    ld hl,0x0000
    call m32_fsadd_callee
    ld a,d
    ld (0x7004),a
    ld a,e
    ld (0x7005),a
    ld a,h
    ld (0x7006),a
    ld a,l
    ld (0x7007),a

    ; 5.0 - 3.0 = 2.0 via fssub: left 5, right 3
    ld de,0x40a0
    ld hl,0x0000
    push de
    push hl
    ld de,0x4040
    ld hl,0x0000
    call m32_fssub_callee
    ld a,d
    ld (0x7008),a
    ld a,e
    ld (0x7009),a
    ld a,h
    ld (0x700A),a
    ld a,l
    ld (0x700B),a

    ; 1.0 + (-1.0) = 0
    ld de,0x3f80
    ld hl,0x0000
    push de
    push hl
    ld de,0xbf80
    ld hl,0x0000
    call m32_fsadd_callee
    ld a,d
    ld (0x700C),a
    ld a,e
    ld (0x700D),a
    ld a,h
    ld (0x700E),a
    ld a,l
    ld (0x700F),a

    ; 0.5 + 0.5 = 1.0
    ld de,0x3f00
    ld hl,0x0000
    push de
    push hl
    ld de,0x3f00
    ld hl,0x0000
    call m32_fsadd_callee
    ld a,d
    ld (0x7010),a
    ld a,e
    ld (0x7011),a
    ld a,h
    ld (0x7012),a
    ld a,l
    ld (0x7013),a

    halt
