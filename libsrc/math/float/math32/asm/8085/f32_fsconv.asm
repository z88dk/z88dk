;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_float* - 8085 int/long → IEEE single
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_float8
PUBLIC m32_float16
PUBLIC m32_float32

PUBLIC m32_float8u
PUBLIC m32_float16u
PUBLIC m32_float32u

EXTERN m32_fsnormalize

; convert signed char in l to float in dehl
.m32_float8
    ld a,l
    rla                             ; sign → C
    sbc a,a
    ld h,a                          ; sign-extend to hl

; convert integer in hl to float in dehl
.m32_float16
    ex de,hl                        ; integer in de
    ld a,d
    rla                             ; sign → C
    sbc a,a
    ld h,a
    ld l,a                          ; hl = sign extension
    ex de,hl                        ; dehl = sign-extended long

; convert long in dehl to float in dehl
.m32_float32
    ex de,hl                        ; hlde
    ld a,h
    ld b,a                          ; B holds sign in bit 7
    rla
    jp NC,dldf0                     ; positive

    ; negate 32-bit hlde → absolute value, keep sign in B
    ; (0x80000000 → 0x80000000 magnitude, handled by dldfright)
    ld a,e
    cpl
    ld e,a
    ld a,d
    cpl
    ld d,a
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    inc de
    ld a,d
    or e
    jp NZ,dldf0
    inc hl
    jp dldf0

; convert character in l to float in dehl
.m32_float8u
    ld h,0

; convert unsigned in hl to float in dehl
.m32_float16u
    ld de,0

; convert unsigned long in dehl to float in dehl
.m32_float32u
    ld b,0                          ; force positive sign
    ex de,hl

.dldf0
; number in hlde, sign in b[7]
    ld c,150                        ; exponent if no shift
    ld a,h
    or a
    jp NZ,dldfright                 ; need right shift
    ; h==0: mantissa already in lde
    jp m32_fsnormalize

; must shift right to make h = 0 and mantissa in lde
.dldfright
    ld a,h
    and 0f0h
    jp Z,dldf4                      ; shift right only 1-4 bits

; here shift right 4-8
    call shr1_hlde
    call shr1_hlde
    call shr1_hlde
    call shr1_hlde                  ; 4 for sure
    ld c,154                        ; exponent for no more shifts

.dldf4
    ld a,h
    or a
    jp Z,dldf8
    call shr1_hlde
    inc c
    ld a,h
    or a
    jp Z,dldf8
    call shr1_hlde
    inc c
    ld a,h
    or a
    jp Z,dldf8
    call shr1_hlde
    inc c
    ld a,h
    or a
    jp Z,dldf8
    call shr1_hlde
    inc c

.dldf8
; pack: mantissa in lde, exponent in c, sign in b[7]
    ld a,l
    add a,a                         ; eject hidden → C
    ld l,a
    ld a,b
    rla                             ; sign → C
    ld a,c
    rra                             ; sign into A[7]
    ld h,a
    ld a,l
    rra
    ld l,a
    ex de,hl                        ; result DEHL
    ret


; logical 32-bit right shift of HLDE through carry chain
.shr1_hlde
    ld a,h
    or a
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret
