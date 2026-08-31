;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; 8080: high 32 of 24-bit square. Same five-term engine as 8085.
; 8×8 via shift-add (no hardware mul). Beats 3×24×8 mulu(x,x).
;
; enter : abc = lde  = 24-bit multiplier  = x
; exit  : hlde  = 32-bit product
;
;------------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_sqr_32h_24x24


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
; Preserves HL (and BC). AF clobbered.
;------------------------------------------------------------------------------
.mulu_de
    inc e
    dec e
    jp Z,mde_ze
    inc d
    dec d
    jp Z,mde_zd

    push hl
    ex de,hl                        ; H = d, L = e
    ld e,l
    ld d,0                          ; DE = multiplicand e

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
    or a
    ret
