
SECTION code_fp_math16

EXTERN  asm_f24_f16

PUBLIC  asm_f16_classify

.asm_f16_classify
    ; enter :   hl  = half x
    ;
    ; exit  :   hl  = half x
    ;            a  = 0 if number
    ;               = 1 if zero
    ;               = 2 if nan
    ;               = 3 if inf
    ;
    ; uses  : af, de
    push hl
    call asm_f24_f16

    ; Zero  -     sign  = whatever
    ;         exponent  = all 0s
    ;         mantissa  = whatever
    ld a,d
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
    ld a,h
    or l
    ld a,3      ;Infinity
    pop hl
    ret Z

    dec a       ;It's NaN
    ret

number:
    pop hl
    xor a
    ret

zero:
    pop hl
    inc a
    ret

