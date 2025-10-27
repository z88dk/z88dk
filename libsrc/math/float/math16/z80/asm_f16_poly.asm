;
;  feilipu, 2020 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_poly - z80, z180, z80n polynomial series evaluation
;-------------------------------------------------------------------------
;
; In mathematics, the term Horner's rule (or Horner's method, Horner's
; scheme etc) refers to a polynomial evaluation method named after
; William George Horner.
;
; This allows evaluation of a polynomial of degree n with only
; n multiplications and n additions.
;
; This is optimal, since there are polynomials of degree n that cannot
; be evaluated with fewer arithmetic operations.
;
; This algorithm is much older than Horner. He himself ascribed it
; to Joseph-Louis Lagrange but it can be traced back many hundreds of
; years to Chinese and Persian mathematicians
;
; half_t poly(const half_t x, const float_t d[], uint16_t n)
; {
;   float_t res = d[n];
;
;   while(n)
;       res = res * x + d[--n];
;
;   return res;
; }
;
; where n is the maximum coefficient index. Same as the C index.
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f32_f24

EXTERN asm_f24_f32
EXTERN asm_f16_f24

EXTERN asm_f24_zero
EXTERN asm_f24_inf
EXTERN asm_f24_nan

EXTERN asm_f24_mul_f24
EXTERN asm_f24_add_f24

PUBLIC asm_f16_poly_callee
PUBLIC asm_f16_poly

.asm_f16_poly_callee
    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float_t d[], half_t x, ret
    ;
    ; exit  : hl    = 16-bit halt_t product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; return
    pop hl                      ; (half_t)x in hl
    exx

    pop de                      ; address of base of coefficient table (float_t)d[]
    pop hl                      ; count n
    push af                     ; return on stack

.asm_f16_poly
    ld b,l                      ; mask n to uint8_t in b, because that's got to be enough coefficients.
    push bc                     ; copy of n on stack in MSB
    dec hl                      ; count of (float_t)d[n-1]

    add hl,hl                   ; point at float_t d[] relative index
    add hl,hl
    add hl,de                   ; create absolute table index from base and relative index
    exx

    call asm_f24_f16            ; expand half_t x to f24
    push de                     ; (f24) x on stack
    push hl
    exx                         ; (f24) x in dehl'

    push hl                     ; absolute table index on stack

    ld e,(hl)                   ; collect (float_t)d[n-1]
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)                   ; sdcc_float_t d[n-1] in bcde
    inc hl
    push bc                     ; sdcc_float_t d[n-1] on stack
    push de

    ld e,(hl)                   ; collect d[n]
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl                    ; sdcc_float_t res = d[n] in dehl
    call asm_f24_f32            ; (f24) d[n] in dehl

.poly0                          ; (f24) x in dehl'
    call asm_f24_mul_f24
    exx                         ; x * res => dehl'

    pop hl                      ; d[--n]
    pop de
    call asm_f24_f32
    call asm_f24_add_f24
    exx                         ; d[--n] + res * x => dehl'

    pop hl                      ; current absolute table index
    pop af                      ; (f24) x lsw from stack
    pop bc                      ; (f24) x msw from stack
    ex af,af
    exx

    pop af                      ; current n value in a
    dec a
    jp Z,asm_f16_f24            ; n value == 0 ? return IEEE half_t in HL

    push af                     ; current n value on stack
    ex af,af
    exx

    push bc                     ; x msw on stack preserved for next iteration
    push af                     ; x lsw on stack preserved for next iteration

    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)
    push de                     ; push d[--n] msw to stack
    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)                   ; (float_t) d[--n] lsw

    ex (sp),hl                  ; next absolute table index to stack
    push hl                     ; push d[--n] msw to stack
    push de                     ; push d[--n] lsw to stack

    ld d,b                      ; (f24) x msw
    ld e,c
    push af                     ; (f24) x lsw
    pop hl
    jp poly0

