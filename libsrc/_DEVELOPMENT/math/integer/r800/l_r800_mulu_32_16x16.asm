
SECTION code_clib
SECTION code_math

PUBLIC l_r800_mulu_32_16x16


    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;         de = 16-bit multiplicand = y
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

l_r800_mulu_32_16x16:
    ; Use the guaranteed to be working instruction
    ld bc,de
    muluw hl,bc    ;Returns dehl = product
    and a
    ret
