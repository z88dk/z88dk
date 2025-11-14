
SECTION code_clib
SECTION code_math

EXTERN l_z80n_mulu_16_16x8
EXTERN l_neg_hl, l_neg_de

PUBLIC l_z80n_muls_16_16x8

l_z80n_muls_16_16x8:

    ; multiplication of a 16-bit signed number by an 8-bit signed number into 16-bit product
    ;
    ; enter :  l =  8-bit signed multiplier
    ;         de = 16-bit signed multiplicand
    ;
    ; exit  : hl = 16-bit signed product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld b,d                       ; d = MSB of multiplicand
    ld c,l                       ; l = MSB of multiplier
    push bc                      ; save sign info

    bit 7,d
    call NZ,l_neg_de             ; take absolute value of multiplicand

    bit 7,l
    call NZ,l_neg_l              ; take absolute value of multiplier

    call l_z80n_mulu_16_16x8     ; do unsigned multiplication

    pop bc                       ; recover sign info from multiplicand and multiplier
    ld a,b
    xor c
    jp M,l_neg_hl                ; negate product if needed, and return
    ret

l_neg_l:
    ld a,l
    cpl
    ld l,a
    inc l
    ret
