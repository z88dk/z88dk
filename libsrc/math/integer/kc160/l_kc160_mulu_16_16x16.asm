
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_mulu_16_16x16

l_kc160_mulu_16_16x16:

    ; multiplication of two 16-bit unsigned numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit unsigned multiplier
    ;         de = 16-bit unsigned multiplicand
    ;
    ; exit  : hl = 16-bit unsigned product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl
    mul de,hl
    and  a
    ret
