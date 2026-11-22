;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_base10 — decimal conversion helper
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_float8, _m32_exp10f, m32_fsmul_callee, m32_fsmul10u_fastcall, m32_fsdiv_callee

PUBLIC m32__dtoa_base10

.m32__dtoa_base10

    ; convert float from standard form "a * 2^n"
    ; to a form multiplied by power of 10 "b * 10^e"
    ; where 1 <= b < 10 with b in double format
    ;
    ; rewritten from math48 code
    ;
    ; enter : DEHL'= double x, x positive
    ;
    ; exit  : DEHL'= b where 1 <= b < 10 all mantissa bits only
    ;          C   = max number of significant decimal digits (7)
    ;          D   = base 10 exponent e
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    ; x = a * 2^n = b * 10^e
    ; e = n * log(2) = n * 0.301.. = n * 0.01001101...(base 2) = INT((n*77 + 5)/256)

    exx
    rl de                       ; move mantissa to capture exponent
    ld a,d                      ; get exponent in A
    rr de

    exx
    ; A = n (binary exponent)
    ; DEHL'= x

    sub $7e                     ; remove excess (bias-1)
    ld l,a
    sbc a,a
    ld h,a                      ; hl = signed n

    push hl                     ; save n
    add hl,hl
    add hl,hl
    push hl                     ; save 4*n
    add hl,hl
    ld bc,hl                    ; bc = 8*n
    add hl,hl
    add hl,hl
    add hl,hl                   ; hl = 64*n
    add hl,bc                   ; hl = 72*n
    pop bc
    add hl,bc                   ; hl = 76*n
    pop bc
    add hl,bc                   ; hl = 77*n
    ld bc,5
    add hl,bc                   ; rounding fudge factor +5

    ld a,h                      ; a = INT((77*n+5)/256)
    push af                     ; save exponent e
    ld l,a                      ; l = e

    bit 7,l
    jr nz, e_negative           ; if e < 0

    ; e >= 0: b = x / 10^e  (10^e is a representable normal float up to
    ; e = 38; multiplying by 10^-e would flush to zero for e = 38 since
    ; 10^-38 is subnormal)

    exx
    push de                     ; push x for fsdiv
    push hl
    exx

    ld l,a                      ; l = e
    call m32_float8             ; convert l to float in DEHL
    call _m32_exp10f            ; make 10^e
    call m32_fsdiv_callee       ; x /= 10^e
    jr e_done

e_negative:

    ; e < 0: b = x * 10^|e|

    neg                         ; a = |e|

    exx
    push de                     ; push x for fsmul
    push hl
    exx

    ld l,a                      ; l = |e|
    call m32_float8             ; convert l to float in DEHL
    call _m32_exp10f            ; make 10^|e|
    call m32_fsmul_callee       ; x *= 10^|e|

e_done:

    ; DEHL = b

    rl de                       ; move mantissa to capture exponent
    ld a,d                      ; get exponent in A
    rr de

    cp $7e+1                    ; remaining fraction part < 1 ?
    jr NC,aligned_digit         ; if no

    pop af
    dec a                       ; e--
    push af
                                ; DEHL = b
    call m32_fsmul10u_fastcall  ; b *= 10

.aligned_digit
    ; DEHL = b, 1 < b < 10

    ; there is one decimal digit in four bits of EHL
    ; align these bits so they are the first four in register D

    rl de                       ; move mantissa to capture exponent
                                ; get exponent in D
    scf                         ; restore mantissa bit
    rr e

    ld a,$7e+4
    sub d

    ld d,e                      ; move mantissa into DEH+L
    ld e,h
    ld h,l
    ld l,0
    jr Z,rotation_done          ; if exponent is 4

.digit_loop
    srl d                       ; shift mantissa bits right
    rr e
    rr hl
    dec a
    jr NZ,digit_loop

.rotation_done
    exx
    pop de                      ; e
    ld c,8                      ; max significant digits (matches m32_fssigdig)
    ret

