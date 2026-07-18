;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 high-32 of 32x32
;
; A6 happy-path: inline word loads via ld hl,(de); skip zero 16-bit limbs.
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_32x32


.m32_mulu_32h_32x32
    pop bc
    push de                     ; x1
    push hl                     ; x0
    push bc
    ; frame: +0 ret +2 x0 +4 x1 +6 y0 +8 y1

    ; ---- p00_hi = high16(x0*y0); abandon p00_lo ----
    ld de,sp+2
    ld hl,(de)                  ; x0
    ld a,h
    or l
    jp Z,p00_zero
    push hl                     ; save x0
    ld de,sp+8                  ; y0 (after push)
    ld hl,(de)
    ld a,h
    or l
    jp Z,p00_zero_x
    ex de,hl                    ; DE = y0
    pop hl                      ; HL = x0
    call mulu_32_16x16          ; DEHL = p00
    push de                     ; p00_hi
    jp p00_done
.p00_zero_x
    pop hl
.p00_zero
    ld de,0
    push de                     ; p00_hi = 0
.p00_done
    ; stack: p00_hi, ret, x0, x1, y0, y1

    ; ---- p01 = x0*y1 ----
    ; stack: p00_hi, ret, x0, x1, y0, y1
    ld de,sp+4
    ld hl,(de)                  ; x0
    ld a,h
    or l
    jp Z,p01_zero
    push hl
    ; after push: x0s, p00_hi, ret, x0, x1, y0, y1 → y1 at +12
    ld de,sp+12
    ld hl,(de)
    ld a,h
    or l
    jp Z,p01_zero_x
    ex de,hl                    ; DE = y1
    pop hl                      ; HL = x0
    call mulu_32_16x16
    push de
    push hl                     ; p01
    jp p01_done
.p01_zero_x
    pop hl
.p01_zero
    ld hl,0
    push hl
    push hl                     ; p01 = 0
.p01_done
    ; stack: p01_lo, p01_hi, p00_hi, ret, x0, x1, y0, y1

    ; ---- p10 = x1*y0 ----
    ld de,sp+10
    ld hl,(de)                  ; x1
    ld a,h
    or l
    jp Z,p10_zero
    push hl
    ; after push: x1s, p01_lo, p01_hi, p00_hi, ret, x0, x1, y0, y1 → y0 at +14
    ld de,sp+14
    ld hl,(de)
    ld a,h
    or l
    jp Z,p10_zero_x
    ex de,hl                    ; DE = y0
    pop hl                      ; HL = x1
    call mulu_32_16x16          ; DEHL = p10
    jp p10_sum
.p10_zero_x
    pop hl
.p10_zero
    ld hl,0
    ld de,0                     ; p10 = 0
.p10_sum
    ; sum = p01 + p10 → DEHL, carry in A as c33
    pop bc                      ; p01_lo
    add hl,bc
    ex de,hl                    ; DE=sum_lo HL=p10_hi
    pop bc                      ; p01_hi
    ld a,l
    adc a,c
    ld l,a
    ld a,h
    adc a,b
    ld h,a                      ; HL=sum_hi, CF=c33
    ld a,0
    rla                         ; A=c33
    ; add p00_hi to sum_lo
    ex de,hl                    ; DE=sum_hi HL=sum_lo
    pop bc                      ; p00_hi
    add hl,bc                   ; sum_lo + p00_hi
    jp NC,add_nc1
    inc de
    push af                     ; save c33
    ld a,d
    or e
    jp NZ,add_nc1b
    pop af
    inc a                       ; wrapped: c33++
    jp add_nc1
.add_nc1b
    pop af
.add_nc1
    push de                     ; mid_hi
    ld b,a
    ld c,0
    push bc                     ; c33 in B
    ; stack: c33, mid_hi, ret, x0, x1, y0, y1

    ; ---- p11 = x1*y1 ----
    ld de,sp+8
    ld hl,(de)                  ; x1
    ld a,h
    or l
    jp Z,p11_zero
    push hl
    ld de,sp+14                 ; y1
    ld hl,(de)
    ld a,h
    or l
    jp Z,p11_zero_x
    ex de,hl                    ; DE = y1
    pop hl                      ; HL = x1
    call mulu_32_16x16          ; DEHL = p11
    jp p11_sum
.p11_zero_x
    pop hl
.p11_zero
    ld hl,0
    ld de,0
.p11_sum
    ; high32 = p11 + mid_hi + (c33<<16)
    pop bc                      ; B=c33, C=0
    ld a,b
    pop bc                      ; mid_hi
    add hl,bc                   ; p11_lo + mid_hi
    ld c,a                      ; C=c33
    ld a,e
    adc a,c
    ld e,a
    ld a,d
    adc a,0
    ld d,a
    ; DEHL = result

    pop bc                      ; ret
    pop af                      ; x0 (discard)
    pop af
    pop af
    pop af
    push bc
    ret


;------------------------------------------------------------------------------
; DE * HL → DEHL  (16×16 → 32)
; Leading-zero skip on DE; product builds in D:A:HL with BC = multiplicand.
;------------------------------------------------------------------------------
.mulu_32_16x16
    ld a,d
    ld d,0
    ld bc,hl
    add a,a
    jp C,b14
    add a,a
    jp C,b13
    add a,a
    jp C,b12
    add a,a
    jp C,b11
    add a,a
    jp C,b10
    add a,a
    jp C,b9
    add a,a
    jp C,b8
    add a,a
    jp C,b7
    ld a,e
    and 0feh
    add a,a
    jp C,b6
    add a,a
    jp C,b5
    add a,a
    jp C,b4
    add a,a
    jp C,b3
    add a,a
    jp C,b2
    add a,a
    jp C,b1
    add a,a
    jp C,b0
    ld a,e
    rra
    ret C
    ld hl,de
    ret
.b14
    add hl,hl
    adc a,a
    jp NC,b13
    add hl,bc
    adc a,d
.b13
    add hl,hl
    adc a,a
    jp NC,b12
    add hl,bc
    adc a,d
.b12
    add hl,hl
    adc a,a
    jp NC,b11
    add hl,bc
    adc a,d
.b11
    add hl,hl
    adc a,a
    jp NC,b10
    add hl,bc
    adc a,d
.b10
    add hl,hl
    adc a,a
    jp NC,b9
    add hl,bc
    adc a,d
.b9
    add hl,hl
    adc a,a
    jp NC,b8
    add hl,bc
    adc a,d
.b8
    add hl,hl
    adc a,a
    jp NC,b7
    add hl,bc
    adc a,d
.b7
    ld d,a
    ld a,e
    and 0feh
    add hl,hl
    adc a,a
    jp NC,b6
    add hl,bc
    adc a,0
.b6
    add hl,hl
    adc a,a
    jp NC,b5
    add hl,bc
    adc a,0
.b5
    add hl,hl
    adc a,a
    jp NC,b4
    add hl,bc
    adc a,0
.b4
    add hl,hl
    adc a,a
    jp NC,b3
    add hl,bc
    adc a,0
.b3
    add hl,hl
    adc a,a
    jp NC,b2
    add hl,bc
    adc a,0
.b2
    add hl,hl
    adc a,a
    jp NC,b1
    add hl,bc
    adc a,0
.b1
    add hl,hl
    adc a,a
    jp NC,b0
    add hl,bc
    adc a,0
.b0
    add hl,hl
    adc a,a
    jp C,fc
    push af                     ; save product mid A (CF=0)
    ld a,e
    rra                         ; CF = original e0
    jp NC,b0_nc
    pop af
    ld e,a
    add hl,bc
    ret NC
    inc e
    ret NZ
    inc d
    ret
.b0_nc
    pop af
    ld e,a
    ret
.fc
    inc d
    push af
    ld a,e
    rra
    jp NC,fc_nc
    pop af
    ld e,a
    add hl,bc
    ret NC
    inc e
    ret
.fc_nc
    pop af
    ld e,a
    ret
