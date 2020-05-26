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
;  asm_f16_inv - z80 half floating point reciprocal 16-bit mantissa
;-------------------------------------------------------------------------
;
; Computes R the quotient of N and D
;
; Express D as M × 2e where 1 ≤ M < 2 (standard floating point representation)
;
; D' := D / 2e+1   // scale between 0.5 and 1
; N' := N / 2e+1
; X := 48/17 − 31/17 × D'   // precompute constants with same precision as D
;
; while
;    X := X + X × (1 - D' × X)
; return N' × X
;
; unpacked format: exponent in d, sign in e[7], mantissa in hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_inf
EXTERN asm_f16_nan

EXTERN asm_f16_f24, asm_f24_f16
EXTERN asm_f24_zero, asm_f24_inf

EXTERN asm_f24_mul_f24

PUBLIC asm_f16_inv_callee
PUBLIC asm_f16_div_callee

PUBLIC asm_f24_inv_callee
PUBLIC asm_f24_div_callee


; enter here for floating asm_f16_div_callee, x+y, x on stack, y in hl, result in hl
.asm_f16_div_callee
    call asm_f16_f24            ; expand to dehl
    call asm_f24_inv

    exx                         ; 1/y   d' = s------- e' = eeeeeeee
                                ;       hl' = 1mmmmmmm mmmmmmmm

    pop bc                      ; pop return address
    pop hl                      ; get second operand off of the stack
    push bc                     ; return address on stack
    call asm_f16_f24            ; expand to dehl
                                ; x      d = s------- e = eeeeeeee
                                ;        hl = 1mmmmmmm mmmmmmmm
    call asm_f24_mul_f24
    jp asm_f24_f16


; enter here for floating asm_f24_add_callee, x+y, x on stack, y in dehl, result in dehl
.asm_f24_div_callee
    call asm_f24_inv
    exx                         ; 1/y   d' = s------- e' = eeeeeeee
                                ;       hl' = 1mmmmmmm mmmmmmmm

    pop bc                      ; pop return address
    pop hl                      ; second  d = s------- e = eeeeeeee
    pop de                      ;        hl = 1mmmmmmm mmmmmmmm
    push bc                     ; return address on stack
    jp asm_f24_mul_f24


; enter here for floating asm_f16_inv, 1/y, y in hl, result in hl
.asm_f16_inv
    call asm_f16_f24
    call asm_f24_inv
    jp asm_f24_f16


; enter here for floating asm_f24_inv, 1/y, y in dehl, result in dehl
.asm_f24_inv
    inc d
    dec c
    jp Z,asm_f24_inf            ; check for zero exponent

    push de                     ; save sign and exponent

    ld h,0bfh                   ; scale to -0.5 <= D' < -1.0
    srl l
    ex de,hl                    ; - D' in DEHL

    push de                     ; - D' msw on stack for D[3] calculation
    push hl                     ; - D' lsw on stack for D[3] calculation
    push de                     ; - D' msw on stack for D[2] calculation
    push hl                     ; - D' lsw on stack for D[2] calculation
    push de                     ; - D' msw on stack for D[1] calculation
    push hl                     ; - D' lsw on stack for D[1] calculation

    sla e
    rl d                        ; get D' full exponent into d
    rr c                        ; put sign in c
    scf
    rr e                        ; put implicit bit for mantissa in ehl
    ld b,d                      ; unpack IEEE to expanded float 32-bit mantissa
    ld d,e
    ld e,h
    ld h,l
    ld l,0
;-------------------------------;
                                ; X = 48/17 − 31/17 × D'
    exx
    ld bc,04034h
    push bc
    ld bc,0B4B5h
    push bc
    ld bc,03FE9h
    push bc
    ld bc,06969h
    push bc
    exx
    call asm_f24_mul_f24         ; (float) 31/17 × D'
    call asm_f24_add_f24         ; X = 48/17 − 31/17 × D'

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[1] calculation
    pop de
    exx
    push bc                     ; X
    push de
    push hl
    push bc                     ; X
    push de
    push hl
    exx
    ld bc,03f80h                ; 1.0
    push bc
    ld bc,0
    push bc
    push de                      ; - D' for D[1] calculation
    push hl
    exx
    call asm_f24_mul_f24         ; (float) - D' × X
    call asm_f24_add_f24         ; (float) 1 - D' × X
    call asm_f24_mul_f24         ; (float) X × (1 - D' × X)
    call asm_f24_add_f24         ; (float) X + X × (1 - D' × X)

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[2] calculation
    pop de
    exx
    push bc                     ; X
    push de
    push hl
    push bc                     ; X
    push de
    push hl
    exx
    ld bc,03f80h                ; 1.0
    push bc
    ld bc,0
    push bc
    push de                      ; - D' for D[2] calculation
    push hl
    exx
    call asm_f24_mul_f24         ; (float) - D' × X
    call asm_f24_add_f24         ; (float) 1 - D' × X
    call asm_f24_mul_f24         ; (float) X × (1 - D' × X)
    call asm_f24_add_f24         ; (float) X + X × (1 - D' × X)

;-------------------------------;
                                ; X := X + X × (1 - D' × X)
    exx
    pop hl                      ; - D' for D[3] calculation
    pop de
    exx
    push bc                     ; X
    push de
    push hl
    push bc                     ; X
    push de
    push hl
    exx
    ld bc,03f80h                ; 1.0
    push bc
    ld bc,0
    push bc
    push de                      ; - D' for D[3] calculation
    push hl
    exx
    call asm_f24_mul_f24         ; (float) - D' × X
    call asm_f24_add_f24         ; (float) 1 - D' × X
    call asm_f24_mul_f24         ; (float) X × (1 - D' × X)
    call asm_f24_add_f24         ; (float) X + X × (1 - D' × X)

;-------------------------------;

    pop af                      ; recover D exponent and sign in C
    rr c                        ; save sign in c
    sub a,07fh                  ; calculate new exponent for 1/D
    neg
    add a,07eh   
    ld b,a

    ld a,l
    ld l,h                      ; align 32-bit mantissa to IEEE 24-bit mantissa
    ld h,e
    ld e,d

    or a                        ; round using feilipu method
    jr Z,fd0
    inc l
    jr NZ,fd0
    inc h
    jr NZ,fd0
    inc e
    jr NZ,fd0
    rr e
    rr h
    rr l
    inc b

.fd0
    sla e
    sla c                       ; recover sign from c
    rr b
    rr e
    ld d,b
    ret                         ; return IEEE DEHL

