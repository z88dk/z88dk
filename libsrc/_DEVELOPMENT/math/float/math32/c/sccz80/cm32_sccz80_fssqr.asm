
; float __fssqr (float number)

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fssqr

EXTERN cm32_sccz80_fsread1, m32_fssqr_fastcall

    ; square (^2) sccz80 floats
    ;
    ; enter : stack = sccz80_float number, ret
    ;
    ; exit  :  DEHL = sccz80_float(number^2)
    ;
    ; uses  : af, bc, de, hl, af'

cm32_sccz80_fssqr:
    call cm32_sccz80_fsread1
    jp m32_fssqr_fastcall
