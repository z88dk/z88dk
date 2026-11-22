

SECTION code_fp_math32

PUBLIC __fmul
EXTERN m32_fsmul

;dehl = iybc * dehl
__fmul:
    push iy
    push bc
    call m32_fsmul
    pop bc
    pop iy
    ret
