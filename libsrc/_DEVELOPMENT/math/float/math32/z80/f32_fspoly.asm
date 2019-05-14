;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_poly - z80, z180, z80-zxn polynomial series evaluation
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
; float polyf(const float x, const float d[], uint16_t n)
; {
;   float res = d[n];
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
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul_callee, m32_fsadd_callee, m32_fsmin_fastcall

PUBLIC m32_fspoly_callee
PUBLIC _m32_poly


.m32_fspoly_callee
._m32_poly

    ; evaluation of a polynomial function
    ;
    ; enter : stack = uint16_t n, float d[], float x, ret
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    pop af                      ; return
    pop hl                      ; (float)x in dehl
    pop de

    exx
    pop de                      ; address of base of coefficient table (float)d[]
    pop hl                      ; count n
    push af                     ; return on stack

    ld a,l                      ; check table has at least 2 elements
    dec a
    or h
    jp Z,m32_fsmin_fastcall

    ld b,l                      ; mask n to uint8_t in b, because that's got to be enough coefficients.
    push bc                     ; copy of n on stack in b
    dec hl                      ; count of (float)d[n-1]

    add hl,hl                   ; point at float relative index
    add hl,hl
    add hl,de                   ; create absolute table index from base and relative index

    exx                      
    push de                     ; (float)x on stack
    push hl

    exx
    push hl                     ; absolute table index on stack
  
    ld e,(hl)                   ; collect (float)d[n-1]
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)                   ; sdcc_float d[n-1] in bcde
    inc hl
    push bc                     ; sdcc_float d[n-1] on stack
    push de

    ld e,(hl)                   ; collect d[n]
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)                   ; sdcc_float res = d[n] in bcde
    push bc                     ; sdcc_float res = d[n] on stack
    push de

    exx

.fep0
    call m32_fsmul_callee       ; x * res => dehl
    call m32_fsadd_callee       ; d[--n] + res * x => dehl
    
    exx
    pop hl                      ; current absolute table index
    pop af                      ; (float)x lsw from stack

    exx
    ex af,af
    pop bc                      ; (float)x msw from stack
    pop af                      ; current n value in a
    dec a
    ret Z                       ; n value == 0 ?

    push af                     ; current n value on stack
    push bc                     ; x msw on stack preserved for next iteration

    exx
    ex af,af
    push af                     ; x lsw on stack preserved for next iteration

    dec hl
    ld b,(hl)
    dec hl
    ld c,(hl)
    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)                   ; sdcc_float d[--n] in bcde

    push hl                     ; next absolute table index

    push bc                     ; push d[--n] to stack
    push de

    exx
    push bc                     ; x msw on stack for this iteration
    push af                     ; x lsw on stack for this iteration
    jr fep0

