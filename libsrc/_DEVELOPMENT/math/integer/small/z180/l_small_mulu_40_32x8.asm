; @feilipu 2018

INCLUDE "config_private.inc"

IF __Z180

SECTION code_clib
SECTION code_math

PUBLIC l_small_z180_mulu_40_32x8

l_small_z180_mulu_40_32x8:

    ; multiplication of 32-bit number and 8-bit number into a 40-bit product
    ;
    ; enter :    a  = 8-bit multiplier     = x
    ;         dehl  = 32-bit multiplicand  = y
    ;            
    ; exit  : adehl = 40-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,d                      ; x3
    ld d,a
    ld b,a

    mlt bc                      ; yl * x3
    mlt de                      ; yl * x2

    push bc
    push de

    ld c,h                      ; x1
    ld h,a
    ld b,a

    mlt bc                      ; yl * x1
    mlt hl                      ; yl * x0

    ld a,h
    add a,c
    ld h,a

    ld a,b
    pop bc
    adc a,c
    ld e,a

    ld a,b
    pop bc
    adc a,c
    ld d,a

    ld a,b
    adc a,0
    ret

ENDIF

