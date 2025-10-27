; 2023 June feilipu

SECTION code_clib
SECTION code_math

EXTERN l_r2ka_mulu_16_16x16

PUBLIC l_r2ka_muls_16_16x16

defc l_r2ka_muls_16_16x16 = l_r2ka_mulu_16_16x16

    ; multiplication of two 16-bit signed numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit signed multiplier
    ;         de = 16-bit signed multiplicand
    ;
    ; exit  : hl = 16-bit signed product
    ;         carry reset
    ;
    ; uses  : f, bc, de, hl
