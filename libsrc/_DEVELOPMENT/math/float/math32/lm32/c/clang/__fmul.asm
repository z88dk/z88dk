

SECTION code_fp_math32

PUBLIC __fmul
EXTERN m32_fsmul_callee

;dehl = dehl * iybc
__fmul:
    push iy
    push bc
    jp m32_fsmul_callee
