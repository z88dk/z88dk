;
;  feilipu, 2020 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div - z80 half floating point divide 16-bit mantissa
;-------------------------------------------------------------------------
; R = N/D = N * 1/D
;
; We calculate division of two floating point number by refining an
; estimate of the reciprocal of y using newton iterations.  Each iteration
; gives us just less than twice previous precision in binary bits (2n-2).
;
; Division is then done by multiplying by the reciprocal of the divisor.
;
;-------------------------------------------------------------------------
;  asm_f16_inv - z80 half floating point reciprocal 16-bit mantissa
;-------------------------------------------------------------------------
;
; Computes R the quotient of N and D
;
; Express D as M × 2e where 1 ≤ M < 2 (standard floating point representation)
;
; D' := D / 2e+1   // scale between 0.5 and 1
; N' := N / 2e+1
; X  := 140/33 + (-64/11 + 256/99 x D') x D'
; precompute constants with same precision as D
;
; while
;    X := X + X × (1 - D' × X)
; return N' × X
;
; unpacked format: exponent in d, sign in e[7], mantissa in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_inf

EXTERN asm_f24_mul_f24

EXTERN asm_f24_add_callee
EXTERN asm_f24_mul_callee

PUBLIC asm_f16_inv
PUBLIC asm_f16_div_callee

PUBLIC asm_f24_inv
PUBLIC asm_f24_div_callee


; enter here for floating asm_f16_div_callee, x+y, x on stack, y in hl, result in hl
.asm_f16_div_callee
    call asm_f24_f16            ; expand to dehl
    call asm_f24_inv
    exx                         ; 1/y   d'  = eeeeeeee e' = s-------
                                ;       hl' = 1mmmmmmm mmmmmmmm
    pop hl                      ; pop return address
    ex (sp),hl                  ; get second operand off of the stack,
                                ; return address on stack
    call asm_f24_f16            ; expand to dehl
                                ; x      d  = eeeeeeee e  = s-------
                                ;        hl = 1mmmmmmm mmmmmmmm
    call asm_f24_mul_f24
    jp asm_f16_f24


; enter here for floating asm_f24_add_callee, x+y, x on stack, y in dehl, result in dehl
.asm_f24_div_callee
    call asm_f24_inv
    jp asm_f24_mul_callee


; enter here for floating asm_f16_inv, 1/y, y in hl, result in hl
.asm_f16_inv
    call asm_f24_f16
    call asm_f24_inv
    jp asm_f16_f24


; enter here for floating asm_f24_inv, 1/y, y in dehl, result in dehl
.asm_f24_inv
    inc d
    dec d
    jp Z,asm_f24_inf            ; check for zero, infinite result

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

