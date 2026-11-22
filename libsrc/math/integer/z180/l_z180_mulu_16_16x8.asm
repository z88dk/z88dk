
SECTION code_clib
SECTION code_math

PUBLIC l_z180_mulu_16_16x8

   ex de,hl

l_z180_mulu_16_16x8:

    ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
    ;
    ; enter :  l =  8-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, de, hl

    ld h,e                      ; yl
    ld e,l                      ; xl

    mlt hl                      ; yl*xl
    mlt de                      ; yh*xl

    ld a,h                      ; sum products
    add a,e                     ; add to msb final
    ld h,a                      ; hl = final

    xor a
    ret
