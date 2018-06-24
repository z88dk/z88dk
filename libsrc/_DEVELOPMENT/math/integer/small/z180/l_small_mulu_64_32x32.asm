
INCLUDE "config_private.inc"

IF __Z180

SECTION code_clib
SECTION code_math

PUBLIC l0_small_z180_mulu_64_32x32

l0_small_z180_mulu_64_32x32:

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : bc'bc = 32-bit multiplier    = x
    ;         de'de = 32-bit multiplicand  = y
    ;         hl'hl = 0
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'




    ; result = hl' hl bc' ac

    ret

ENDIF

