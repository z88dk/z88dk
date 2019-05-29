
; float __fsdiv_callee (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fsdiv_callee

EXTERN cm32_sccz80_fsread1_callee
EXTERN m32_fsdiv_callee

    ; divide sccz80 float by sccz80 float
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float(left/right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

.cm32_sccz80_fsdiv_callee
    call cm32_sccz80_fsread1_callee
    jp m32_fsdiv_callee     ; enter stack = sccz80_float left, ret
                            ;        DEHL = sccz80_float right
                            ; return DEHL = sccz80_float
