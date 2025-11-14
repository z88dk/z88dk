
SECTION code_fp_math32

PUBLIC __fsub
EXTERN m32_fsadd

;dehl = iybc - dehl
;We have to preserve iybc
__fsub:
    ;; Toggle sign bit and add
    ld a,d
    xor $80
    ld d,a

    push iy
    push bc
    call m32_fsadd
    pop bc
    pop iy
    ret