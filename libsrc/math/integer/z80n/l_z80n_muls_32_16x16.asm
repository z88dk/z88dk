
SECTION code_clib
SECTION code_math

EXTERN l_z80n_mulu_32_16x16
EXTERN l_neg_hl, l_neg_de, l_neg_dehl

PUBLIC l_z80n_muls_32_16x16

l_z80n_muls_32_16x16:

    ; multiplication of two 16-bit signed numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit signed multiplier   = x
    ;         de = 16-bit signed multiplicand = y
    ;
    ; exit  : dehl = 32-bit signed product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld b,d                      ; d = MSB of multiplicand
    ld c,h                      ; h = MSB of multiplier
    push bc                     ; save sign info

    bit 7,d
    call NZ,l_neg_de            ; take absolute value of multiplicand

    bit 7,h
    call NZ,l_neg_hl            ; take absolute value of multiplier

    call l_z80n_mulu_32_16x16   ; do unsigned multiplication

    pop bc                      ; recover sign info from multiplicand and multiplier
    ld a,b
    xor c
    jp M,l_neg_dehl             ; negate product if needed, and return
    ret
