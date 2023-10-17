SECTION code_clib
SECTION code_math

PUBLIC l_r800_mulu_16_16x16

EXTERN l_r800_mulu_32_16x16



    ; multiplication of two 16-bit numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : bc, de, hl
defc l_r800_mulu_16_16x16 = l_r800_mulu_32_16x16
