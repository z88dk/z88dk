;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_poly - z80, z180, z80n polynomial series evaluation
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

EXTERN m32_fsmul24x32, m32_fsadd24x32

PUBLIC m32_fspoly_callee
PUBLIC _m32_polyf


._m32_polyf
.m32_fspoly_callee
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

    ld b,l                      ; mask n to uint8_t in b, because that's got to be enough coefficients.
    push bc                     ; copy of n on stack
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
    sla e
    sla d                       ; get full exponent into d
    rr c                        ; put sign in c
    scf
    rr e                        ; put implicit bit for mantissa in ehl
    ld b,d                      ; unpack IEEE to expanded float 32-bit mantissa
    ld d,e
    ld e,h
    ld h,l
    ld l,0                      ; (float)x in bc dehl

.fep0
    call m32_fsmul24x32         ; x * res => bc dehl
    call m32_fsadd24x32         ; d[--n] + res * x => bc dehl
    
    exx
    pop hl                      ; current absolute table index
    pop af                      ; (float)x lsw from stack
    pop bc                      ; (float)x msw from stack

    exx
    ex af,af
    pop af                      ; current n value in a
    dec a
    jr Z,fep1                   ; n value == 0 ?

    push af                     ; current n value on stack

    exx
    ex af,af
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
    ld e,(hl)                   ; sdcc_float d[--n] lsw

    ex (sp),hl                  ; next absolute table index to stack
    push hl                     ; push d[--n] msw to stack
    push de                     ; push d[--n] lsw to stack

    push bc                     ; x msw on stack for this iteration
    push af                     ; x lsw on stack for this iteration

    exx
    jr fep0

.fep1
    ld a,l
    ld l,h                      ; align 32-bit mantissa to IEEE 24-bit mantissa
    ld h,e
    ld e,d

    and 080h                    ; round using feilipu method
    jr Z,fep2
    set 0,l

.fep2
    sla e
    sla c                       ; recover sign from c
    rr b
    rr e
    ld d,b
    ret                         ; return IEEE DEHL
