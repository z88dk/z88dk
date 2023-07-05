

SECTION code_fp_math32

PUBLIC __fadd
EXTERN m32_fsadd_callee

;dehl = dehl + iybc
__fadd:
    push iy
    push bc
    jp m32_fsadd_callee
