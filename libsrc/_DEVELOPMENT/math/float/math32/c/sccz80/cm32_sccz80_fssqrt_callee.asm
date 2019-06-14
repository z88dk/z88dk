
; float __fssqrt_callee (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fssqrt_callee

EXTERN cm32_sccz80_fsread1_callee, m32_fssqrt_fastcall

    ; square root sccz80 float
    ;
    ; enter : stack = ret
    ;          DEHL = sccz80_float number
    ;
    ; exit  :  DEHL = sccz80_float(number^0.5)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'
    
cm32_sccz80_fssqrt_callee:
    call cm32_sccz80_fsread1_callee
    jp m32_fssqrt_fastcall
