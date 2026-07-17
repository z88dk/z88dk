; Golden-vector test for m32_mulu_32h_24x24
; Result bytes stored at result; expected at expect; match flag at ok
    org 0
    di
    ld sp,0x8000
    jp main

    include "../asm/8085/f32_8085_mulu_32h_24x24.asm"

main:
    ; --- vector 0: 0x800000 * 0x800000 => 0x40000000 ---
    ld l,0x80
    ld d,0x00
    ld e,0x00
    ld h,0
    push de                     ; y.DE
    push hl                     ; y.HL L=0x80
    ld l,0x80
    ld d,0x00
    ld e,0x00
    call m32_mulu_32h_24x24
    ; HLDE should be 0x40000000 -> H=0x40 L=0x00 D=0x00 E=0x00
    ld a,h
    ld (result0),a
    ld a,l
    ld (result0+1),a
    ld a,d
    ld (result0+2),a
    ld a,e
    ld (result0+3),a

    ; --- vector 1: 0xFFFFFF * 0xFFFFFF => (0xFFFFFE000001)>>16 = 0xFFFFFE00 ---
    ld l,0xFF
    ld d,0xFF
    ld e,0xFF
    ld h,0
    push de
    push hl
    ld l,0xFF
    ld d,0xFF
    ld e,0xFF
    call m32_mulu_32h_24x24
    ld a,h
    ld (result1),a
    ld a,l
    ld (result1+1),a
    ld a,d
    ld (result1+2),a
    ld a,e
    ld (result1+3),a

    ; --- vector 2: 0x123456 * 0xABCDEF ---
    ld l,0xAB
    ld d,0xCD
    ld e,0xEF
    ld h,0
    push de
    push hl
    ld l,0x12
    ld d,0x34
    ld e,0x56
    call m32_mulu_32h_24x24
    ld a,h
    ld (result2),a
    ld a,l
    ld (result2+1),a
    ld a,d
    ld (result2+2),a
    ld a,e
    ld (result2+3),a

    ; --- vector 3: 0x000001 * 0x000001 => 0 ---
    ld l,0
    ld d,0
    ld e,1
    ld h,0
    push de
    push hl
    ld l,0
    ld d,0
    ld e,1
    call m32_mulu_32h_24x24
    ld a,h
    ld (result3),a
    ld a,l
    ld (result3+1),a
    ld a,d
    ld (result3+2),a
    ld a,e
    ld (result3+3),a

    ; --- vector 4: 0x800001 * 0x800001 ---
    ld l,0x80
    ld d,0x00
    ld e,0x01
    ld h,0
    push de
    push hl
    ld l,0x80
    ld d,0x00
    ld e,0x01
    call m32_mulu_32h_24x24
    ld a,h
    ld (result4),a
    ld a,l
    ld (result4+1),a
    ld a,d
    ld (result4+2),a
    ld a,e
    ld (result4+3),a

    halt
    jp $

result0: defs 4
result1: defs 4
result2: defs 4
result3: defs 4
result4: defs 4
