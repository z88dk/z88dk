
; float __fshypot_callee (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fshypot_callee

EXTERN cm32_sccz80_fsreadl_callee, m32_fshypot_callee

    ; find the hypotenuse of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

cm32_sccz80_fshypot_callee:
    call cm32_sccz80_fsreadl_callee
    jp m32_fshypot_callee
