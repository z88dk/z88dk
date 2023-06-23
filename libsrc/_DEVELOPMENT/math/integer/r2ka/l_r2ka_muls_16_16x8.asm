; 2023 June feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_r2ka_muls_16_16x8

l_r2ka_muls_16_16x8:

    ; multiplication of a 16-bit signed number by an 8-bit signed number into 16-bit product
    ;
    ; enter :  l =  8-bit signed multiplier
    ;         de = 16-bit signed multiplicand
    ;
    ; exit  : hl = 16-bit signed product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,l                      ; multiplier to c

    ld a,c                      ; c = LSB of multiplier
    rla                         ; sign to carry to extend
    sbc a,a
    ld b,a                      ; bc = sign extended 16 bit multiplier

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    ld hl,bc                    ; signed result to hl

    or a
    ret
