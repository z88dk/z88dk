    org 0
    di
    ld sp,0x8000
    jp main

    include "../asm/8085/f32_8085_mulu_32h_24x24.asm"
    include "../asm/8085/f32_fsmul.asm"
    include "../asm/f32_fsconst.asm"

; helper: call m32_fsmul_callee with left DEHL_L, right DEHL_R
; store result at (bc)
main:
    ; 1.0 * 2.0 = 2.0
    ; 1.0 = 0x3f800000 -> D=3f E=80 H=00 L=00
    ; 2.0 = 0x40000000
    ld de,0x3f80
    ld hl,0x0000
    push de
    push hl                     ; left 1.0
    ld de,0x4000
    ld hl,0x0000                ; right 2.0
    call m32_fsmul_callee
    ld a,d
    ld (0x7000),a
    ld a,e
    ld (0x7001),a
    ld a,h
    ld (0x7002),a
    ld a,l
    ld (0x7003),a

    ; 0.5 * 0.5 = 0.25
    ; 0.5=0x3f000000 0.25=0x3e800000
    ld de,0x3f00
    ld hl,0x0000
    push de
    push hl
    ld de,0x3f00
    ld hl,0x0000
    call m32_fsmul_callee
    ld a,d
    ld (0x7004),a
    ld a,e
    ld (0x7005),a
    ld a,h
    ld (0x7006),a
    ld a,l
    ld (0x7007),a

    ; -3 * 4 = -12
    ; 3=0x40400000 -3=0xc0400000 4=0x40800000 -12=0xc1400000
    ld de,0xc040
    ld hl,0x0000
    push de
    push hl
    ld de,0x4080
    ld hl,0x0000
    call m32_fsmul_callee
    ld a,d
    ld (0x7008),a
    ld a,e
    ld (0x7009),a
    ld a,h
    ld (0x700A),a
    ld a,l
    ld (0x700B),a

    ; 1.5 * 1.5 = 2.25
    ; 1.5=0x3fc00000 2.25=0x40100000
    ld de,0x3fc0
    ld hl,0x0000
    push de
    push hl
    ld de,0x3fc0
    ld hl,0x0000
    call m32_fsmul_callee
    ld a,d
    ld (0x700C),a
    ld a,e
    ld (0x700D),a
    ld a,h
    ld (0x700E),a
    ld a,l
    ld (0x700F),a

    ; 0 * 5 = 0
    ld de,0x0000
    ld hl,0x0000
    push de
    push hl
    ld de,0x40a0
    ld hl,0x0000
    call m32_fsmul_callee
    ld a,d
    ld (0x7010),a
    ld a,e
    ld (0x7011),a
    ld a,h
    ld (0x7012),a
    ld a,l
    ld (0x7013),a

    halt
