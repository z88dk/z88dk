

SECTION code_fp_math32

PUBLIC __fdiv
EXTERN m32_fsdiv

;dehl = iybc / dehl
__fdiv:
    push iy
    push bc
    call m32_fsdiv
    pop bc
    pop iy
    ret