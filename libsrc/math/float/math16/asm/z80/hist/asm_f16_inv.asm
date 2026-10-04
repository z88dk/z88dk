;
;  feilipu, 2020 May / 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_inv / asm_f24_inv - z80 half float reciprocal (Newton–Raphson)
;-------------------------------------------------------------------------
;
; D' := D / 2^(e+1) ∈ [0.5, 1); seed + two NR refinements on f24.
; unpacked f24: exponent in d, sign in e[7], mantissa in hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_inf

EXTERN asm_f24_add_callee
EXTERN asm_f24_mul_callee

PUBLIC asm_f16_inv
PUBLIC asm_f24_inv


; enter here for floating asm_f16_inv, 1/y, y in hl, result in hl
.asm_f16_inv
    ld a,$7c                    ; packed half specials at boundary only
    and h
    cp $7c
    jr Z,inv_half_max

    call asm_f24_f16
    call asm_f24_inv
    jp asm_f16_f24

.inv_half_max
    ld a,h                      ; Inf → ±0, NaN → qNaN
    and 003h
    or l
    jr NZ,inv_half_nan
    and a                       ; clear
    ld a,h
    and 080h
    ld h,a
    ld l,0
    ret                         ; signed zero

.inv_half_nan
    ld hl,07C80h                ; +qNaN
    ret


; enter here for floating asm_f24_inv, 1/y, y in dehl, result in dehl
.asm_f24_inv
    ld a,d
    or a
    jp Z,asm_f24_inf            ; 1/0 → ±Inf (sign in e)

    push de                     ; save sign and exponent

    ld de,07e80h                ; scale to -0.5 <= D' < -1.0

    push de                     ; - D' msw on stack for D[2] calculation
    push hl                     ; - D' lsw on stack for D[2] calculation
    push de                     ; - D' msw on stack for D[1] calculation
    push hl                     ; - D' lsw on stack for D[1] calculation

;-------------------------------;
                                ; X = 140/33 + (-64/11 + 256/99 x D') x D'
    ld bc,08100h                ; (f24) 140/33
    push bc
    ld bc,087c1h
    push bc
    res 7,e                     ; set D' positive
    push de                     ; D' msw on stack for D[0] calculation
    push hl                     ; D' lsw on stack for D[0] calculation
    ld bc,08180h                ; (f24) -64/11
    push bc
    ld bc,0ba2fh
    push bc
    ld bc,08000h                ; (f24) 256/99
    push bc
    ld bc,0a57fh
    push bc
    call asm_f24_mul_callee     ; (f24) 256/99 × D'
    call asm_f24_add_callee     ; (f24) X = -64/11 + 256/99 × D'
    call asm_f24_mul_callee     ; (f24) X = (-64/11 + 256/99 × D') x D'
    call asm_f24_add_callee     ; (f24) X = 140/33 + (-64/11 + 256/99 × D') x D'

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[1] calculation
    pop de
    exx
    push de                     ; X
    push hl
    push de                     ; X
    push hl
    exx
    ld bc,07f00h                ; 1.0
    push bc
    ld bc,08000h
    push bc
    push de                      ; - D' for D[1] calculation
    push hl
    exx
    call asm_f24_mul_callee     ; (f24) - D' × X
    call asm_f24_add_callee     ; (f24) 1 - D' × X
    call asm_f24_mul_callee     ; (f24) X × (1 - D' × X)
    call asm_f24_add_callee     ; (f24) X + X × (1 - D' × X)

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[2] calculation
    pop de
    exx
    push de                     ; X
    push hl
    push de                     ; X
    push hl
    exx
    ld bc,07f00h                ; 1.0
    push bc
    ld bc,08000h
    push bc
    push de                      ; - D' for D[2] calculation
    push hl
    exx
    call asm_f24_mul_callee     ; (f24) - D' × X
    call asm_f24_add_callee     ; (f24) 1 - D' × X
    call asm_f24_mul_callee     ; (f24) X × (1 - D' × X)
    call asm_f24_add_callee     ; (f24) X + X × (1 - D' × X)

;-------------------------------;

    pop de                      ; recover exponent and sign e[7]
    ld a,d
    sub a,07fh                  ; calculate new exponent for 1/D
    neg
    add a,07eh
    ld d,a                      ; new exponent to d
    ret                         ; return f24 in DEHL
