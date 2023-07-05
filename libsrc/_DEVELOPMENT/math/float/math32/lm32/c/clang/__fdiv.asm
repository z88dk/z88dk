

SECTION code_fp_math32

PUBLIC __fdiv
EXTERN m32_fsdiv_callee

;dehl = dehl / iybc
__fdiv:
    push de
    push hl
    push iy
    pop  de
    ld hl,bc
    jp m32_fsdiv_callee
