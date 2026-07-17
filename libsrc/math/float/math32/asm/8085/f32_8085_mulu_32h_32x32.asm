;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 high-32 of 32x32

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_mulu_32h_32x32


.m32_mulu_32h_32x32
    pop bc
    push de                     ; x1
    push hl                     ; x0
    push bc
    ; ret x0 x1 y0 y1

    ; ---- p00 = x0*y0; store full 32 on stack as (hi, lo) we need p00_hi ----
    ld de,sp+2
    call ld_hl
    ld de,sp+6
    call ld_de
    call mulu_32_16x16
    push de                     ; p00_hi (p00_lo abandoned)

    ; ---- p01 = x0*y1 ----
    ld de,sp+4
    call ld_hl
    ld de,sp+10
    call ld_de
    call mulu_32_16x16
    push de
    push hl                     ; p01

    ; ---- p10 = x1*y0 ----
    ld de,sp+10
    call ld_hl                  ; x1
    ld de,sp+12
    call ld_de                  ; y0
    call mulu_32_16x16
    ; sum = p01 + p10  (32-bit) into DEHL, carry in A
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
    ; DE=sum_lo HL=sum_hi A=c33
    ; add p00_hi to sum_lo
    ex de,hl                    ; DE=sum_hi HL=sum_lo
    pop bc                      ; p00_hi
    add hl,bc                   ; sum_lo + p00_hi
    jp NC,add_nc1
    ; mid_hi++ with carry into A (INX does not set Z!)
    inc de
    push af                     ; save c33
    ld a,d
    or e
    jp NZ,add_nc1b              ; no wrap
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

    ; ---- p11 = x1*y1 ----
    ld de,sp+8
    call ld_hl                  ; x1
    ld de,sp+12
    call ld_de                  ; y1
    call mulu_32_16x16          ; DEHL = p11
    ; high32 = p11 + mid_hi + (c33<<16)
    pop bc                      ; B=c33, C=0
    ld a,b
    pop bc                      ; mid_hi in BC
    add hl,bc                   ; p11_lo + mid_hi
    ld c,a                      ; C=c33
    ld a,e
    adc a,c                     ; p11_hi_lo + c33 + CF
    ld e,a
    ld a,d
    adc a,0
    ld d,a
    ; DEHL = result

    pop bc                      ; ret
    pop af                      ; x0
    pop af
    pop af
    pop af
    push bc
    ret


.ld_hl
    push de
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ret

.ld_de
    push hl
    call ld_hl
    ex de,hl
    pop hl
    ret


.mulu_32_16x16
    ld a,d
    ld d,0
    ld b,h
    ld c,l
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
    ld h,d
    ld l,e
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
    ; NC path: product overflow CF=0
    push af                     ; save product mid A (and CF=0)
    ld a,e
    rra                         ; CF = original e0
    jp NC,b0_nc
    pop af                      ; A = product mid
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
    rra                         ; CF was 1 from overflow; shifts into e, e0->CF
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
