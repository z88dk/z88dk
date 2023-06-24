; 2023 June feilipu

SECTION code_clib
SECTION code_math

EXTERN l_mulu_32_16x16

PUBLIC l_r2ka_mulu_32_32x32, l0_r2ka_mulu_32_32x32

l0_r2ka_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl'= 16-bit multiplier   = y
    ;         hl = 16-bit multiplicand = x
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    ex de,hl'
    jp l_mulu_32_16x16

l_r2ka_mulu_32_32x32:

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : de hl = 32-bit multiplier
    ;         de'hl'= 32-bit multiplicand
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    xor a
    or e
    or d
    exx

    or e
    or d
    jr Z,l0_r2ka_mulu_32_16x16  ; demote if both are uint16_t

    ex de',hl
    ld bc,hl
    exx

    ld bc,hl

l0_r2ka_mulu_32_32x32:

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : de de' = 32-bit multiplier   = x
    ;         bc bc' = 32-bit multiplicand = y
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    ; keep low words in DE as they are preserved during multiply
    ;
    ; signed multiply of BC and DE, result in HL:BC

    ld hl',bc                   ; yh
    ld bc,de                    ; xh
    exx

    ld de',bc                   ; yl
    ld bc,hl                    ; yh

    ; enter : bc'de = 32-bit multiplier   = x
    ;         bc de' = 32-bit multiplicand = y
    ;
    ; multiply the MSWs and add, then multiply and add LSW

    mul                         ; yh * xl
    exx

    mul                         ; xh * yl
    ld hl',bc
    exx

    add hl,bc                   ; hl = partial result LSW(yh * xl + xh * yl)
    ld bc',de
    exx

    mul                         ; hlbc = yl * xl
    ld bc',bc
    ex de',hl
    exx

    add hl,de                   ; hl = LSW(yh * xl + xh * yl) + (yl * xl)

    ex de,hl
    ld hl,bc                    ; result to dehl

    or a                        ; carry reset
    ret                         ; exit  : dehl = 32-bit product
