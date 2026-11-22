
; float __fsmul_callee (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC _m32_mul_callee
PUBLIC cm32_sdcc_fsmul_callee

EXTERN cm32_sdcc_fsreadr_callee, m32_fsmul_callee

DEFC _m32_mul_callee = cm32_sdcc_fsmul_callee

.cm32_sdcc_fsmul_callee

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadr_callee
    jp m32_fsmul_callee     ; enter stack = sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
