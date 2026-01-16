
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

    ld bc,hl

    ld a,16
    ld hl,0

loop_0:
    ; bc = 16-bit multiplicand
    ; de = 16-bit multiplicand
    ;  a = iterations

    add hl,hl
    rl de

    jp NC,loop_1
    add hl,bc
    jp NC,loop_1
    inc de

loop_1:
    dec a
    jp NZ,loop_0

    or a
    ret
