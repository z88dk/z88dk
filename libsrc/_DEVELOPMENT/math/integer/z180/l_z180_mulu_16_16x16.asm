; 2017 dom / feilipu
; 2017 aralbrec - slightly faster

SECTION code_clib
SECTION code_math

PUBLIC l_z180_mulu_16_16x16

l_z180_mulu_16_16x16:

    ; multiplication of two 16-bit numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld a,d                      ; a = xh
    ld d,h                      ; d = yh
    ld h,a                      ; h = xh
    ld c,e                      ; c = xl
    ld b,l                      ; b = yl
    mlt de                      ; yh*xl
    mlt hl                      ; xh*yl
    add hl,de                   ; add cross products
    mlt bc                      ; yl*xl
    ld a,l                      ; cross products lsb
    add a,b                     ; add to msb final
    ld h,a
    ld l,c                      ; hl = final

    xor a
    ret
