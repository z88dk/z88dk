;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085: high 32 bits of 24x24 unsigned product
;
; Happy-path optimised (A1/A2):
;  - open-coded 32-bit accumulate (no adc hl,bc library stub)
;  - word load of x.DE via ld hl,(de); load_x inlined into passes
;  - skip a y-byte pass when that byte is zero
;  - 24x8: product B:A:HL; multiplicand C:DE (same algorithm as Z80 core)
;  - LZ path restores mid from C (no push af during leading-zero scan)
;
; A4: m32_sqr_32h_24x24 — dedicated square (5×8×8, skip c*c) instead of
;     general 24×24. Same high-32 truncation as Z80n/Z180 sqr.
;     8×8 via mulu_de = l_small_mulu_de (shift-add; no 512B table).
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_24x24
PUBLIC m32_l0_mulu_32h_24x24
PUBLIC m32_sqr_32h_24x24


;------------------------------------------------------------------------------
; A4: square high-32 of 24×24. enter LDE = a:b:c ; exit HLDE = product
;
; (a*a)<<32 + (2*a*b)<<24 + (b*b + 2*a*c)<<16 + (2*b*c)<<8
; c*c omitted (bits 0–15 only). Same layout as Z80n/Z180 sqr.
; 8×8 via mulu_de = l_small_mulu_de (unrolled shift-add).
;------------------------------------------------------------------------------
.m32_sqr_32h_24x24
    ld h,l                          ; HL = a:a
    push hl                         ; aa
    ld l,d                          ; HL = a:b
    push hl                         ; ab
    ld d,h                          ; DE = a:c
    ld h,l                          ; HL = b:b
    push hl                         ; bb
    push de                         ; ac
    ld l,e                          ; HL = b:c

    ex de,hl                        ; DE = b:c
    call mulu_de                    ; DE = b*c
    ex de,hl                        ; HL = b*c

    xor a
    add hl,hl
    adc a,a                         ; AHL = 2*b*c
    ld c,h
    ld b,a                          ; BC = (2*b*c) >> 8

    pop de                          ; ac
    pop hl                          ; bb
    push bc                         ; (2*bc)>>8
    push hl                         ; bb
    call mulu_de                    ; DE = a*c
    pop hl                          ; HL = b:b
    push de                         ; a*c
    ex de,hl                        ; DE = b:b
    call mulu_de                    ; DE = b*b
    pop hl                          ; HL = a*c
    pop bc                          ; BC = (2*bc)>>8

    xor a
    add hl,hl
    adc a,a                         ; 2*a*c
    add hl,de
    adc a,0                         ; + b*b
    add hl,bc
    adc a,0                         ; + (2*b*c)>>8
    ld c,h
    ld b,a                          ; BC = mid high; L = mid low

    pop de                          ; ab
    call mulu_de                    ; DE = a*b
    ex de,hl                        ; HL = a*b; DE = mid (E = mid low)

    xor a
    add hl,hl
    adc a,a                         ; 2*a*b
    add hl,bc
    adc a,0                         ; + mid high
    ld c,e                          ; mid low
    ld b,l
    ld l,h
    ld h,a                          ; HL = top16, BC = next16

    pop de                          ; aa
    push bc
    call mulu_de                    ; DE = a*a
    add hl,de
    pop de                          ; DE = low 16
    ret


;------------------------------------------------------------------------------
; mulu_de — 8×8→16 (l_small_mulu_de algorithm).
; enter: D, E = factors; exit: DE = product, C reset.
; Preserves HL (and BC — not used). AF clobbered.
; 8085: sla h → ld a,h / add a,a / ld h,a
;------------------------------------------------------------------------------
.mulu_de
    inc e
    dec e
    jp Z,mde_ze                     ; ×0
    inc d
    dec d
    jp Z,mde_zd                     ; ×0

    push hl
    ex de,hl                        ; H = d, L = e
    ld e,l
    ld d,0                          ; DE = multiplicand e

    ; eliminate leading zero bits of multiplier H
    ld a,h
    add a,a
    ld h,a
    jp C,mde_11
    ld a,h
    add a,a
    ld h,a
    jp C,mde_12
    ld a,h
    add a,a
    ld h,a
    jp C,mde_13
    ld a,h
    add a,a
    ld h,a
    jp C,mde_14
    ld a,h
    add a,a
    ld h,a
    jp C,mde_15
    ld a,h
    add a,a
    ld h,a
    jp C,mde_16
    ld a,h
    add a,a
    ld h,a
    jp C,mde_17
    jp mde_exit1                    ; ×1

.mde_ze
    ld d,e
    ret

.mde_zd
    ld e,d
    ret

.mde_11
    add hl,hl
    jp NC,mde_12
    add hl,de
.mde_12
    add hl,hl
    jp NC,mde_13
    add hl,de
.mde_13
    add hl,hl
    jp NC,mde_14
    add hl,de
.mde_14
    add hl,hl
    jp NC,mde_15
    add hl,de
.mde_15
    add hl,hl
    jp NC,mde_16
    add hl,de
.mde_16
    add hl,hl
    jp NC,mde_17
    add hl,de
.mde_17
    add hl,hl
    jp NC,mde_exit
    add hl,de
.mde_exit
    ex de,hl
.mde_exit1
    pop hl
    or a                            ; clear C (match l_small_mulu_de)
    ret


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
    or a
    jp Z,p1_zero
    ; inline load_x (CDE = x, A = y.E preserved)
    ; after push af: +0 af +2 ret +4 xHL +6 xDE
    push af
    ld de,sp+4
    ld a,(de)
    ld c,a
    ld de,sp+6
    ld hl,(de)
    ex de,hl
    pop af
    call mulu_32_24x8
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
    ld de,sp+13
    ld a,(de)                   ; y.D
    or a
    jp Z,p2_zero
    ; after push af: +0 af +2 accL +4 accH +6 ret +8 xHL +10 xDE
    push af
    ld de,sp+8
    ld a,(de)
    ld c,a
    ld de,sp+10
    ld hl,(de)
    ex de,hl
    pop af
    call mulu_32_24x8
    pop hl                      ; accL
    add hl,de
    ex de,hl
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
    ld de,sp+10
    ld a,(de)                   ; y.L
    or a
    jp Z,p3_zero
    ; after push af: +0 af +2 accL +4 accH +6 ret +8 xHL +10 xDE
    push af
    ld de,sp+8
    ld a,(de)
    ld c,a
    ld de,sp+10
    ld hl,(de)
    ex de,hl
    pop af
    call mulu_32_24x8
    pop hl
    add hl,de
    ex de,hl
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
;------------------------------------------------------------------------------
.mulu_32_24x8
    or a
    jp Z,m24_zero

    ld b,a                      ; B = multiplier
    ld hl,de                    ; HL = xl (product low init)

    ; leading-zero scan on multiplier; product mid restored from C at entry
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
