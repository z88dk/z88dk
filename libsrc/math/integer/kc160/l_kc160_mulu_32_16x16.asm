
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_mulu_32_16x16

l_kc160_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : de = 16-bit multiplicand
    ;         hl = 16-bit multiplicand
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : de, hl
  
    mul     de,hl
    and     a
    ret
