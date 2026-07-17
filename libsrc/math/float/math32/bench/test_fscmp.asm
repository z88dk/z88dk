    org 0
    di
    ld sp,0x8000
    ; 1 ? 2
    ld de,0x3f80
    ld hl,0
    push de
    push hl
    ld de,0               ; dummy ret_real
    push de
    ld de,0x4000
    ld hl,0
    call m32_compare_callee
    ld a,0
    jp NC,f1
    ld a,1
.f1
    ld (0x7000),a
    ld a,0
    jp Z,f1z
    ld a,1
.f1z
    ld (0x7001),a

    ; 2 ? 2
    ld de,0x4000
    ld hl,0
    push de
    push hl
    ld de,0
    push de
    ld de,0x4000
    ld hl,0
    call m32_compare_callee
    ld a,0
    jp NZ,f2
    ld a,1
.f2
    ld (0x7002),a
    ld a,0
    jp C,f2c
    ld a,1
.f2c
    ld (0x7003),a

    ; -1 ? 1
    ld de,0xbf80
    ld hl,0
    push de
    push hl
    ld de,0
    push de
    ld de,0x3f80
    ld hl,0
    call m32_compare_callee
    ld a,0
    jp NC,f3
    ld a,1
.f3
    ld (0x7004),a

    ; 0 ? -0
    ld de,0
    ld hl,0
    push de
    push hl
    ld de,0
    push de
    ld de,0x8000
    ld hl,0
    call m32_compare_callee
    ld a,0
    jp NZ,f4
    ld a,1
.f4
    ld (0x7005),a

    ; 3 ? 1
    ld de,0x4040
    ld hl,0
    push de
    push hl
    ld de,0
    push de
    ld de,0x3f80
    ld hl,0
    call m32_compare_callee
    ld a,0
    jp C,f5
    ld a,1
.f5
    ld (0x7006),a
    ld a,0
    jp Z,f5z
    ld a,1
.f5z
    ld (0x7007),a

    halt
    include "../asm/8085/f32_fscompare.asm"
