
SECTION code_fp_math32

PUBLIC __ltof
EXTERN m32_float32

; dehl = float(iybc)
__ltof:
    push iy
    push bc
    pop hl
    pop de
    jp m32_float32

