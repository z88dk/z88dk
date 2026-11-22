
SECTION code_clib
SECTION code_math

PUBLIC l_z180_mulu_32_16x16

l_z180_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;         de = 16-bit multiplicand = y
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld b,l                      ; xl
    ld c,d                      ; yh
    ld d,l                      ; xl
    ld l,c
    push hl                     ; xh yh
    ld l,e                      ; yl

    ; bc = xl yh
    ; de = xl yl
    ; hl = xh yl
    ; stack = xh yh

    mlt de                      ; xl*yl
    mlt bc                      ; xl*yh
    mlt hl                      ; xh*yl

    xor a                       ; zero A
    add hl,bc                   ; sum cross products
    adc a,a                     ; capture carry
    ld b,a                      ; carry from cross products
    ld c,h                      ; LSB of MSW from cross products

    ld a,d
    add a,l
    ld d,a                      ; de = final LSW

    pop hl
    mlt hl                      ; xh*yh

    adc hl,bc                   ; hl = final MSW
    ex de,hl

    ret
