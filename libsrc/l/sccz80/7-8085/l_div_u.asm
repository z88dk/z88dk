;   sccz80 crt0 library - 8085 version
;
;   feilipu 10/2021

SECTION code_clib
SECTION code_l_sccz80

PUBLIC  l_div_u
PUBLIC  l_div_0

; HL = DE / HL, DE = DE % HL
.l_div_u
    ld      bc,hl           ;copy divisor to bc

; HL = DE / BC, DE = DE % BC
.l_div_0
    ld      hl,0            ;clear remainder
    ld      a,8             ;16 bits (8 iterations)

.div_loop
    rl      de              ;left shift dividend + quotient carry
    ex      de,hl
    rl      de              ;left shift remainder + dividend carry
    ex      de,hl

    sub     hl,bc           ;substract divisor from remainder
    jp      NC,skip_revert0 ;if remainder < divisor, add back divisor

    add     hl,bc           ;revert subtraction of divisor

.skip_revert0
    ccf                     ;complement carry

    rl      de              ;left shift dividend + quotient carry
    ex      de,hl
    rl      de              ;left shift remainder + dividend carry
    ex      de,hl

    sub     hl,bc           ;substract divisor from remainder
    jp      NC,skip_revert1 ;if remainder < divisor, add back divisor

    add     hl,bc           ;revert subtraction of divisor

.skip_revert1
    ccf                     ;complement carry

    dec     a               ;decrement loop counter
    jp      NZ,div_loop

    rl      de              ;left shift dividend + quotient carry
    ex      de,hl           ;dividend<>remainder
    ret
