; 2023 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_r2ka_mulu_16_16x16

l_r2ka_mulu_16_16x16:

    ; multiplication of two 16-bit numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : f, bc, de, hl

    ld bc,hl                    ; multiplier to bc

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    ld hl,bc                    ; result to hl

    or a
    ret
