;
; 8085 IEEE fpclassify
;
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fpclassify

.m32_fpclassify
    ; enter : dehl = float x
    ; exit  : dehl = float x
    ;            a = 0 number, 1 zero, 2 nan, 3 inf
    ; uses  : af
    rl de                       ; 8085 extended: exp into d, sign into C
    ld a,d
    ld b,a                      ; save exponent
    ld a,d                      ; restore de (rr de)
    rra
    ld d,a
    ld a,e
    rra
    ld e,a

    ld a,b
    or a
    jr Z,zero

    cpl
    or a
    jr NZ,number

    ld a,e
    add a,a                     ; shift out mantissa MSB (was low exp bit path)
    or h
    or l
    ld a,3                      ; Infinity
    ret Z
    dec a                       ; NaN
    ret

.number
    xor a
    ret

.zero
    inc a
    ret
