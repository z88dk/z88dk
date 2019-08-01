
SECTION code_fp_math32

PUBLIC m32_fpclassify

m32_fpclassify:
    ; enter : dehl  = float x
    ;
    ; exit  : dehl  = float x
    ;            a  = 0 if number
    ;               = 1 if zero
    ;               = 2 if nan
    ;               = 3 if inf
    ;
    ; uses  : af
    sla e
    rl d
    ld a,d
    rr d
    rr e

    ; Zero  -     sign  = whatever
    ;         exponent  = all 0s
    ;         mantissa  = whatever
    or a
    jr Z,zero

    ; Number -   sign  = whatever
    ;        exponent  = not all 1s
    ;        mantissa  = whatever
    cpl
    or a
    jr NZ,number

    ; Infinity - sign  = whatever
    ;        exponent  = all 1s
    ;         mantissa = all 0s
    ; NaN      - sign  = whatever
    ;        exponent  = all 1s
    ;        mantissa  = not 0

    ; So we could be NaN, or Inf here
    ld a,e
    rla
    or h
    or l
    ld a,3      ;Infinity
    ret Z

    dec a       ;It's NaN
    ret

number:
    xor    a
    ret

zero:
    inc    a
    ret

