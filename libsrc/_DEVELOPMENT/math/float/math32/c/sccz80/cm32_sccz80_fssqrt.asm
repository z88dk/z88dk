
; float __fssqrt (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fssqrt

EXTERN cm32_sccz80_fsread1, m32_fssqrt_fastcall

    ; square root sccz80 float
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

cm32_sccz80_fssqrt:
    call cm32_sccz80_fsread1
    jp m32_fssqrt_fastcall
