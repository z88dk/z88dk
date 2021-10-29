;   sccz80 crt0 library - 8085 version
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

EXTERN  l_hlneg
EXTERN  l_deneg
EXTERN  l_bcneg

PUBLIC  l_div

; HL = DE / HL, DE = DE % HL
.l_div
    ld      bc,hl
    ld      a,d
    xor     b
    push    af              ;save de^hl for sign
    ld      a,d
    or      a
    call    M,l_deneg
    ld      a,b
    or      a
    call    M,l_bcneg

    ld      bc,hl           ;store divisor to bc
    ld      hl,0            ;clear remainder
    ld      a,8             ;16 bits (8 iterations)
.div_loop
    rl      de              ;left shift dividend + quotient carry
    ex      de,hl
    rl      de              ;left shift remainder + dividend carry
    ex      de,hl

    sub     hl,bc           ;substract divisor from remainder
    jp      NK,skip_revert0 ;if remainder < divisor, add back divisor

    add     hl,bc           ;revert subtraction of divisor
    scf                     ;set carry to complement

.skip_revert0
    ccf                     ;complement carry

    rl      de              ;left shift dividend + quotient carry
    ex      de,hl
    rl      de              ;left shift remainder + dividend carry
    ex      de,hl

    sub     hl,bc           ;substract divisor from remainder
    jp      NK,skip_revert1 ;if remainder < divisor, add back divisor

    add     hl,bc           ;revert subtraction of divisor
    scf                     ;set carry to complement

.skip_revert1
    ccf                     ;complement carry

    dec     a               ;decrement loop counter
    jp      NZ,div_loop

    rl      de              ;left shift dividend + quotient carry
    ex      de,hl           ;dividend<>remainder

    pop     af
    ret     P
    call    l_deneg
    call    l_hlneg
    ret

