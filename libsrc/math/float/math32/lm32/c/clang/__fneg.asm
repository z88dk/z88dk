

SECTION code_fp_math32

PUBLIC __fneg

;dehl = -iybc
__fneg:
    push iy
    pop de
    ld hl,bc
    ld a,d
    xor $80
    ld d,a
    ret
    