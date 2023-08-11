; 2023 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_r2ka_mulu_16_16x8

   ex de,hl

l_r2ka_mulu_16_16x8:

    ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
    ;
    ; enter :  l =  8-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : bc, de, hl

    ld c,l                      ; multiplier to bc
    ld b,0                      ; extended 16 bit unsigned multiplier

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    ld hl,bc                    ; result to hl

    or a
    ret
