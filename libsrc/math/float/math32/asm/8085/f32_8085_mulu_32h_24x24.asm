;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085: high 32 bits of 24x24 unsigned product

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_24x24
PUBLIC m32_l0_mulu_32h_24x24
PUBLIC m32_sqr_32h_24x24


.m32_sqr_32h_24x24
    pop bc
    push de
    push hl
    push bc


.m32_mulu_32h_24x24
.m32_l0_mulu_32h_24x24
    ; frame: ret, x.HL, x.DE, y.HL, y.DE
    pop bc
    push de
    push hl
    push bc
    ; sp+0 ret +2 xHL +4 xDE +6 yHL +8 yDE

    ; pass1: x * y.E >> 8
    ld de,sp+8
    ld a,(de)                   ; y.E
    call load_x_cde
    call mulu_32_24x8
    ld e,d
    ld d,c
    ld c,b
    ld b,0
    push bc
    push de
    ; +0 accL +2 accH +4 ret +6 xHL +8 xDE +10 yHL +12 yDE

    ; pass2: x * y.D + acc >> 8
    ld de,sp+13
    ld a,(de)                   ; y.D
    call load_x_cde_acc
    call mulu_32_24x8
    pop hl
    add hl,de
    ex de,hl
    pop hl
    adc hl,bc
    ld e,d
    ld d,l
    ld c,h
    ld b,0
    push bc
    push de

    ; pass3: x * y.L + acc
    ld de,sp+10
    ld a,(de)                   ; y.L
    call load_x_cde_acc
    call mulu_32_24x8
    pop hl
    add hl,de
    ex de,hl
    pop hl
    adc hl,bc
    ; HLDE = product

    pop bc                      ; ret
    pop af                      ; xHL
    pop af                      ; xDE
    pop af                      ; yHL
    pop af                      ; yDE
    push bc
    ret


; After call+push af: +0 af +2 ret_load +4 frame_ret +6 xHL +8 xDE
; Must not clobber pointer in DE when reading two bytes.
.load_x_cde
    push af
    ld de,sp+6
    ld a,(de)
    ld c,a                      ; C = x.L
    ld de,sp+8
    ld a,(de)
    ld l,a                      ; temp x.E
    inc de
    ld a,(de)
    ld d,a                      ; D = x.D
    ld e,l                      ; E = x.E
    pop af
    ret


; After call+push af with acc: +0 af +2 ret_load +4 accL +6 accH +8 ret +10 xHL +12 xDE
.load_x_cde_acc
    push af
    ld de,sp+10
    ld a,(de)
    ld c,a
    ld de,sp+12
    ld a,(de)
    ld l,a
    inc de
    ld a,(de)
    ld d,a
    ld e,l
    pop af
    ret


;------------------------------------------------------------------------------
; CDE * A -> BCDE  (24x8 -> 32)
;------------------------------------------------------------------------------
.mulu_32_24x8
    or a
    jp Z,m24_zero

    ld b,a
    ld a,c
    ld hl,de

    push af
    ld a,b
    add a,a
    ld b,a
    jp C,lz1
    ld a,b
    add a,a
    ld b,a
    jp C,lz2
    ld a,b
    add a,a
    ld b,a
    jp C,lz3
    ld a,b
    add a,a
    ld b,a
    jp C,lz4
    ld a,b
    add a,a
    ld b,a
    jp C,lz5
    ld a,b
    add a,a
    ld b,a
    jp C,lz6
    ld a,b
    add a,a
    ld b,a
    jp C,lz7
    ld a,b
    add a,a
    ld b,a
    pop af
    jp m18

.lz1
    pop af
    jp m11
.lz2
    pop af
    jp m12
.lz3
    pop af
    jp m13
.lz4
    pop af
    jp m14
.lz5
    pop af
    jp m15
.lz6
    pop af
    jp m16
.lz7
    pop af
    jp m17

.m24_zero
    ld b,0
    ld c,b
    ld d,b
    ld e,b
    ret

.m11
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m11s
    pop af
    add hl,de
    adc a,c
    jp NC,m12
    inc b
    jp m12
.m11s
    pop af
.m12
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m12s
    pop af
    add hl,de
    adc a,c
    jp NC,m13
    inc b
    jp m13
.m12s
    pop af
.m13
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m13s
    pop af
    add hl,de
    adc a,c
    jp NC,m14
    inc b
    jp m14
.m13s
    pop af
.m14
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m14s
    pop af
    add hl,de
    adc a,c
    jp NC,m15
    inc b
    jp m15
.m14s
    pop af
.m15
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m15s
    pop af
    add hl,de
    adc a,c
    jp NC,m16
    inc b
    jp m16
.m15s
    pop af
.m16
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m16s
    pop af
    add hl,de
    adc a,c
    jp NC,m17
    inc b
    jp m17
.m16s
    pop af
.m17
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    jp NC,m17s
    pop af
    add hl,de
    adc a,c
    jp NC,m18
    inc b
    jp m18
.m17s
    pop af
.m18
    ld c,a
    ex de,hl
    ret
