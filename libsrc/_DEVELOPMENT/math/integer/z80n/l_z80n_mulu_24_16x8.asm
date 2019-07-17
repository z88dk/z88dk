; 2018 July feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_z80n_mulu_24_16x8

l_z80n_mulu_24_16x8:

    ; multiplication of 16-bit number and 8-bit number into a 24-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;          e =  8-bit multiplicand = y
    ;
    ; exit  : ahl = 24-bit product
    ;         carry reset
    ;
    ; uses  : af, de, hl

    ld d,h                      ; xh
    ld h,e                      ; yl

    mul de                      ; xh*yl
    ex de,hl
    mul de                      ; yl*xl, hl = xh*yl

    ld  a,d                     ; sum products
    add a,l
    ld  d,a
    ex de,hl

    ld  a,d
    adc a,0
    ret
