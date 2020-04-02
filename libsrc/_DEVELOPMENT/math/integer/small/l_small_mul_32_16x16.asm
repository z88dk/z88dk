
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
IF __CPU_INTEL__
    push af
ENDIF

    ; bc = 16-bit multiplicand
    ; de = 16-bit multiplicand
    ;  a = iterations

    add hl,hl
IF __CPU_INTEL__
    ld a,e
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
ELSE
    rl e
    rl d
ENDIF

    jr NC,loop_1
    add hl,bc
    jr NC,loop_1
    inc de

loop_1:
IF __CPU_INTEL__
    pop af
ENDIF
    dec a
    jr NZ,loop_0

    or a
    ret
