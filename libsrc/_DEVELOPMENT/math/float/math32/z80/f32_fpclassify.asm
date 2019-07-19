
SECTION code_fp_math32

PUBLIC m32_fpclassify

m32_fpclassify:
    ; enter : dehl' = double x
    ;
    ; exit  : dehl' = double x
    ;            a  = 0 if number
    ;               = 1 if zero
    ;               = 2 if nan
    ;               = 3 if inf
    ;
    ; uses  : af
    exx
    sla e
    rl d
    ld a,d
    rr d
    rr e
    or a
    jr Z,zero

    ; Infinity - sign = whatever
    ;         exponent = all 1s;
    ;            mantissa = 0
    ; Nan       - sign = whatever
    ;         exponent = all 1s;
    ;            mantissa = not 0
    cpl
    or a
    jr NZ,number

    ; So we could be NaN, or inf here
    ld a,e
    rla
    or h
    or l

    exx
    ld a,3      ;infinity
    ret Z
    dec a       ;It's NaN
    ret

number:
    exx
    xor    a
    ret

zero:
    exx
    inc    a
    ret

