
; float __fssub_callee (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC _m32_sub_callee
PUBLIC cm32_sdcc_fssub_callee

EXTERN cm32_sdcc_fsreadr_callee, m32_fssub_callee

DEFC _m32_sub_callee = cm32_sdcc_fssub_callee

.cm32_sdcc_fssub_callee

    ; subtract sdcc float from sdcc float
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left-right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cm32_sdcc_fsreadr_callee
    jp m32_fssub_callee     ; enter stack = sdcc_float left, ret
                            ;        DEHL = sdcc_float right
                            ; return DEHL = sdcc_float
