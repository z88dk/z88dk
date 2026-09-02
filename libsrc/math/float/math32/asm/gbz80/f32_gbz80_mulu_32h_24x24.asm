;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; gbz80: high 32 bits of 24x24 unsigned product
;
; Same three-pass engine as 8085.  Frame access via ld hl,sp+n and
; ld r,(hl) — no ld de,sp+*, ld hl,(de), or exx.
;
; 24x8 inner: product B:A:HL, multiplicand C:DE (same as Z80/8085).
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_24x24
PUBLIC m32_l0_mulu_32h_24x24


.m32_mulu_32h_24x24
.m32_l0_mulu_32h_24x24
    ; frame: ret, x.HL, x.DE, y.HL, y.DE
    pop bc
    push de
    push hl
    push bc
    ; sp+0 ret +2 xHL +4 xDE +6 yHL +8 yDE

    ; pass1: x * y.E >> 8
    ld hl,sp+8
    ld a,(hl)                   ; y.E
    or a
    jp Z,p1_zero
    push af
    ld hl,sp+4
    ld c,(hl)                   ; x.L
    ld hl,sp+6
    ld e,(hl+)
    ld d,(hl)                   ; x.DE
    pop af                      ; A = y.E
    call mulu_32_24x8           ; in CDE=x A=y.E; out BCDE=32-bit
    ld e,d
    ld d,c
    ld c,b
    ld b,0
    jp p1_store
.p1_zero
    ld b,0
    ld c,b
    ld d,b
    ld e,b
.p1_store
    push bc
    push de
    ; +0 accL +2 accH +4 ret +6 xHL +8 xDE +10 yHL +12 yDE

    ; pass2: x * y.D + acc >> 8
    ld hl,sp+13
    ld a,(hl)                   ; y.D
    or a
    jp Z,p2_zero
    push af
    ld hl,sp+8
    ld c,(hl)                   ; x.L
    ld hl,sp+10
    ld e,(hl+)
    ld d,(hl)                   ; x.DE
    pop af                      ; A = y.D
    call mulu_32_24x8           ; in CDE=x A=y.D; out BCDE=32-bit
    pop hl                      ; accL
    add hl,de
    ld de,hl                    ; DE = sum (old DE discarded)
    pop hl                      ; accH
    jp NC,p2_nc
    inc hl
.p2_nc
    add hl,bc
    ld e,d
    ld d,l
    ld c,h
    ld b,0
    jp p2_store
.p2_zero
    pop de                      ; accL
    pop bc                      ; accH
    ld e,d
    ld d,c
    ld c,b
    ld b,0
.p2_store
    push bc
    push de

    ; pass3: x * y.L + acc
    ld hl,sp+10
    ld a,(hl)                   ; y.L
    or a
    jp Z,p3_zero
    push af
    ld hl,sp+8
    ld c,(hl)                   ; x.L
    ld hl,sp+10
    ld e,(hl+)
    ld d,(hl)                   ; x.DE
    pop af                      ; A = y.L
    call mulu_32_24x8           ; in CDE=x A=y.L; out BCDE=32-bit
    pop hl
    add hl,de
    ld de,hl                    ; DE = sum (old DE discarded)
    pop hl
    jp NC,p3_nc
    inc hl
.p3_nc
    add hl,bc
    jp p3_done
.p3_zero
    pop de
    pop hl
.p3_done

    pop bc                      ; ret
    pop af                      ; xHL
    pop af                      ; xDE
    pop af                      ; yHL
    pop af                      ; yDE
    push bc
    ret


;------------------------------------------------------------------------------
; CDE * A -> BCDE  (24x8 -> 32)
; product B:A:HL, multiplicand C:DE, multiplier bits dual-use in B
; gbz80: CB rl b / sla b (no push-af rotate as on 8080)
;------------------------------------------------------------------------------
.mulu_32_24x8
    or a
    jp Z,m24_zero

    ld b,a                      ; B = multiplier
    ld hl,de                    ; HL = xl (product low init)

    ; leading-zero scan; CB sla (gbz80). Product mid restored from C.
    sla b
    jp C,lz1
    sla b
    jp C,lz2
    sla b
    jp C,lz3
    sla b
    jp C,lz4
    sla b
    jp C,lz5
    sla b
    jp C,lz6
    sla b
    jp C,lz7
    sla b
    ld a,c
    jp m18

.lz1
    ld a,c
    jp m11
.lz2
    ld a,c
    jp m12
.lz3
    ld a,c
    jp m13
.lz4
    ld a,c
    jp m14
.lz5
    ld a,c
    jp m15
.lz6
    ld a,c
    jp m16
.lz7
    ld a,c
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
    rl b
    jr NC,m11s

    add hl,de
    adc a,c
    jp NC,m12
    inc b
    jp m12

.m11s
.m12
    add hl,hl
    rla
    rl b
    jr NC,m12s

    add hl,de
    adc a,c
    jp NC,m13
    inc b
    jp m13

.m12s
.m13
    add hl,hl
    rla
    rl b
    jr NC,m13s

    add hl,de
    adc a,c
    jp NC,m14
    inc b
    jp m14

.m13s
.m14
    add hl,hl
    rla
    rl b
    jr NC,m14s

    add hl,de
    adc a,c
    jp NC,m15
    inc b
    jp m15

.m14s
.m15
    add hl,hl
    rla
    rl b
    jr NC,m15s

    add hl,de
    adc a,c
    jp NC,m16
    inc b
    jp m16

.m15s
.m16
    add hl,hl
    rla
    rl b
    jr NC,m16s

    add hl,de
    adc a,c
    jp NC,m17
    inc b
    jp m17

.m16s
.m17
    add hl,hl
    rla
    rl b
    jr NC,m17s

    add hl,de
    adc a,c
    jp NC,m18
    inc b
    jp m18

.m17s
.m18
    ld c,a
    ld de,hl                        ; BCDE = product
    ret
