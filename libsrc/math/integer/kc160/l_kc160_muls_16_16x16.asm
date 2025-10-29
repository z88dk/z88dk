
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_muls_16_16x16

l_kc160_muls_16_16x16:

    ; multiplication of two 16-bit signed numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit signed multiplier
    ;         de = 16-bit signed multiplicand
    ;
    ; exit  : hl = 16-bit signed product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl
    muls de,hl
    and  a
    ret
