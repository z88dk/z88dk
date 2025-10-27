

SECTION code_fp_math32

PUBLIC __fadd
EXTERN m32_fsadd

;dehl = iybc + dehl
;We have to preserve iybc
__fadd:
    push iy
    push bc
    call m32_fsadd
    pop bc
    pop iy
    ret
