
SECTION code_clib
SECTION code_fp_math32

EXTERN m32_float8, _m32_exp10f, m32_fsmul_callee, m32_fsmul10u_fastcall

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
    sla e                       ; move mantissa to capture exponent
    rl d
    ld a,d                      ; get exponent in A
    rr d
    rr e

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
    ld c,l
    ld b,h                      ; bc = 8*n
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
    neg                         ; -e

    exx
    push de                     ; push x for fsmul
    push hl 

    ld l,a                      ; -e
    call m32_float8             ; convert L to float in DEHL
    call _m32_exp10f            ; make 10^-e
    call m32_fsmul_callee       ; x *= 10^-e

    ; DEHL = b

    sla e                       ; move mantissa to capture exponent
    rl d
    ld a,d                      ; get exponent in A
    rr d
    rr e

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

    sla e                       ; move mantissa to capture exponent
    rl d                        ; get exponent in D
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
    rr h 
    rr l
    dec a
    jr NZ,digit_loop

.rotation_done
    exx
    pop de                      ; e
    ld c,7                      ; max significant digits
    ret

