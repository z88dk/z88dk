
; 2018 feilipu

SECTION code_clib
SECTION code_math

PUBLIC l_small_mul_32_16x16

l_small_mul_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : de = 16-bit multiplicand
    ;         hl = 16-bit multiplicand
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,l
    ld b,h

    ld a,16
    ld hl,0

loop_0:

    ; bc = 16-bit multiplicand
    ; de = 16-bit multiplicand
    ;  a = iterations

    add hl,hl

    rl e
    rl d

    jr NC,loop_1
    add hl,bc
    jr NC,loop_1
    inc de

loop_1:
    dec a
    jr NZ,loop_0

    or a
    ret
