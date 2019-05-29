
; float __fshypot (float left, float right)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fshypot

EXTERN cm32_sccz80_fsreadl, m32_fshypot

    ; find the hypotenuse of two sccz80 floats
    ;
    ; enter : stack = sccz80_float left, sccz80_float right, ret
    ;
    ; exit  :  DEHL = sccz80_float(left+right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

cm32_sccz80_fshypot:
    call cm32_sccz80_fsreadl
    jp m32_fshypot
