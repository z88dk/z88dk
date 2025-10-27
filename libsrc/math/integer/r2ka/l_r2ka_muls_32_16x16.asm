; 2023 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_r2ka_muls_32_16x16

l_r2ka_muls_32_16x16:

    ; multiplication of two 16-bit signed numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit signed multiplier   = x
    ;         de = 16-bit signed multiplicand = y
    ;
    ; exit  : dehl = 32-bit signed product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl


    ld bc,hl                    ; multiplier to bc

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    ex de,hl
    ld hl,bc                    ; result to dehl

    or a
    ret
